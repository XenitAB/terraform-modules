locals {
  calico_version = "v3.19"
  cni_script = templatefile("${path.module}/templates/update-eks-cni.sh.tpl", {
    b64_cluster_ca = aws_eks_cluster.this.certificate_authority[0].data,
    api_server_url = aws_eks_cluster.this.endpoint
    token          = data.aws_eks_cluster_auth.this.token
    calico_version = local.calico_version
  })
  # The new token would cause the script to change all the time, this is just used to calculate the trigger hash
  cni_script_check = templatefile("${path.module}/templates/update-eks-cni.sh.tpl", {
    b64_cluster_ca = aws_eks_cluster.this.certificate_authority[0].data,
    api_server_url = aws_eks_cluster.this.endpoint
    token          = "foobar"
    calico_version = local.calico_version
  })
  eks_cluster_name = "${var.environment}-${var.name}${var.eks_name_suffix}"
}

data "aws_subnet" "cluster" {
  for_each = {
    for i in ["0", "1"] :
    i => i
  }

  filter {
    name = "tag:Name"
    values = [
      "${var.name}${var.eks_name_suffix}-cluster-${each.value}"
    ]
  }
}

#tfsec:ignore:AWS067
resource "aws_eks_cluster" "this" {
  provider = aws.eks_admin

  name     = local.eks_cluster_name
  role_arn = var.cluster_role_arn
  version  = var.eks_config.kubernetes_version

  enabled_cluster_log_types = ["api", "audit"]

  #tfsec:ignore:AWS069 tfsec:ignore:AWS068
  vpc_config {
    subnet_ids              = [for s in data.aws_subnet.cluster : s.id]
    endpoint_private_access = true
    public_access_cidrs     = var.eks_authorized_ips #tfsec:ignore:AWS068
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.aws_kms_key_arn
    }
  }

  tags       = local.global_tags
  depends_on = [aws_cloudwatch_log_group.this]
}



# CloudWatch Encrytion
resource "aws_kms_key" "cloudwatch_encryption" {
  description         = "Used for cloudwatch encryption"
  enable_key_rotation = true

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${var.region}.amazonaws.com" },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
            "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/${local.eks_cluster_name}}/cluster"
        }
      }
    }
  ]
}
EOF

  tags = merge(
    local.global_tags,
    {
      Name = "CloudWatch Encrytion"
    },
  )
}
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${local.eks_cluster_name}}/cluster"
  retention_in_days = var.eks_cloudwatch_retention_period
  kms_key_id        = var.cloudwatch_aws_kms_key_arn

  tags = local.global_tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"

  tags = local.global_tags

  depends_on = [aws_eks_node_group.this]
}

resource "aws_eks_addon" "core_dns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"

  tags = local.global_tags

  depends_on = [aws_eks_node_group.this]
}

data "tls_certificate" "thumbprint" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.thumbprint.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = local.global_tags
}

data "aws_eks_cluster_auth" "this" {
  provider = aws.eks_admin

  name = aws_eks_cluster.this.name
}

# This is a sad dirty trick as there is no way to opt-out
# of EKS installing the VPC CNI. EKS will not try to create
# the daemonset again after you delete. First it deletes the AWS CNI
# and then it installs the Calico CNI.
resource "null_resource" "update_eks_cni" {
  triggers = {
    script_hash = "${sha256(local.cni_script_check)}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = local.cni_script
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}

data "aws_subnet" "node" {
  for_each = {
    for i in ["0", "1", "2"] :
    i => i
  }

  filter {
    name = "tag:Name"
    values = [
      "${var.name}${var.eks_name_suffix}-nodes-${each.value}"
    ]
  }
}

# Required to override the default max pod limit set by default based on instance type
resource "aws_launch_template" "eks_node_group" {
  for_each = {
    for node_group in var.eks_config.node_groups :
    node_group.name => node_group
  }

  name                   = "${aws_eks_cluster.this.name}-${each.value.name}"
  vpc_security_group_ids = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }
  user_data = base64encode(templatefile("${path.module}/templates/userdata.sh.tpl", {
    cluster_name   = aws_eks_cluster.this.name,
    b64_cluster_ca = aws_eks_cluster.this.certificate_authority[0].data,
    api_server_url = aws_eks_cluster.this.endpoint
    node_group     = "${aws_eks_cluster.this.name}-${each.value.name}"
  }))

  tags = local.global_tags
}

resource "aws_eks_node_group" "this" {
  provider = aws.eks_admin
  for_each = {
    for node_group in var.eks_config.node_groups :
    node_group.name => node_group
  }
  depends_on = [null_resource.update_eks_cni]

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${aws_eks_cluster.this.name}-${each.value.name}"
  node_role_arn   = var.node_group_role_arn
  instance_types  = each.value.instance_types
  release_version = each.value.release_version
  scaling_config {
    desired_size = each.value.min_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  subnet_ids = [for s in data.aws_subnet.node : s.id]

  launch_template {
    id      = aws_launch_template.eks_node_group[each.key].id
    version = aws_launch_template.eks_node_group[each.key].latest_version
  }

  tags = local.global_tags

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  timeouts {
    create = "15m"
    update = "15m"
  }
}
