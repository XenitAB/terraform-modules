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

resource "aws_eks_cluster" "this" { #tfsec:ignore:AWS067
  provider = aws.eks_admin

  name     = "${var.name}${var.eks_name_suffix}-${var.environment}"
  role_arn = var.cluster_role_arn
  version  = var.eks_config.kubernetes_version

  vpc_config {
    subnet_ids = [for s in data.aws_subnet.cluster : s.id] #tfsec:ignore:AWS069 tfsec:ignore:AWS068
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.aws_kms_key_arn
    }
  }

  tags = {
    Name        = "${var.name}${var.eks_name_suffix}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "core_dns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}

# This is a sad dirty trick as there is no way to opt-out
# of EKS installing the VPC CNI. EKS will not try to create
# the daemonset again after you delete.
# Also installs calico
resource "null_resource" "update_eks_cni" {
  #triggers = {
  #  always_run = uuid()
  #}

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOT
      TMPDIR=$(mktemp -d) && \
      KUBECONFIG="$TMPDIR/config" && \
      kubectl config set clusters.cluster-admin.server ${aws_eks_cluster.this.endpoint} && \
      kubectl config set clusters.cluster-admin.certificate-authority-data ${aws_eks_cluster.this.certificate_authority[0].data} && \
      kubectl config set users.cluster-admin.token ${data.aws_eks_cluster_auth.this.token} && \
      kubectl config set contexts.cluster-admin.cluster cluster-admin && \
      kubectl config set contexts.cluster-admin.user cluster-admin && \
      kubectl config set contexts.cluster-admin.namespace kube-system && \
      kubectl --context=cluster-admin delete ds aws-node -n kube-system --ignore-not-found=true
      kubectl --context=cluster-admin apply -f https://docs.projectcalico.org/manifests/calico-vxlan.yaml
    EOT
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

  tags = {
    Name        = "${aws_eks_cluster.this.name}-${each.value.name}"
    Environment = var.environment
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

}

data "tls_certificate" "thumbprint" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.thumbprint.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_eks_cluster_auth" "this" {
  provider = aws.eks_admin

  name = aws_eks_cluster.this.name
}


