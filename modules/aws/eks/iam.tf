# EKS Cluster
resource "aws_iam_role" "iamRoleEksCluster" {
  name = "iam-role-eks-${var.environment}-${var.locationShort}-${var.commonName}-cluster"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# EKS Node Group
resource "aws_iam_role" "iamRoleEksNodeGroup" {
  name = "iam-role-eks-${var.environment}-${var.locationShort}-${var.commonName}-nodegroup"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# AWS Auth
locals {
  cluster_access_types = toset(["cluster-admin", "cluster-viewer"])
  namespace_types = toset([
    for product in setproduct(var.namespaces, ["edit", "view"]) :
    "${product[0]}-${product[1]}"
  ])
}

# cluster
resource "kubernetes_cluster_role_binding" "cluster_access" {
  for_each = local.cluster_access_types
  metadata {
    name = "crb-${each.value}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }
  subject {
    kind      = "Group"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "aws_iam_role" "cluster_access" {
  for_each = local.cluster_access_types
  name     = "iam-role-eks-${each.value}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }]
    Version = "2012-10-17"
  })
}

data "aws_iam_policy_document" "cluster_access" {
  for_each = local.cluster_access_types
  version  = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole", ]
    resources = [aws_iam_role.cluster_access[each.key].arn, ]
  }
}

resource "aws_iam_policy" "cluster_access" {
  for_each = local.cluster_access_types
  name     = "iam-policy-eks-${each.value}"
  policy   = data.aws_iam_policy_document.cluster_access[each.key].json
}

resource "aws_iam_group" "cluster_access" {
  for_each = local.cluster_access_types
  name     = "iam-group-eks-${each.value}"
}

resource "aws_iam_group_policy_attachment" "cluster_access" {
  for_each   = local.cluster_access_types
  group      = aws_iam_group.cluster_access[each.key].name
  policy_arn = aws_iam_policy.cluster_access[each.key].arn
}


# namespace
resource "kubernetes_namespace" "namespace" {
  for_each = var.namespaces
  metadata {
    name = each.value
    labels = {
      name = each.value
    }
    annotations = {
      "externalsecrets.kubernetes-client.io/permitted-key-name" = "eks/wks/${each.value}/.*"
    }
  }
}

resource "kubernetes_role_binding" "namespace" {
  for_each = local.namespace_types
  metadata {
    name      = "rb-${each.value}"
    namespace = element(split("-", each.value), 0)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = element(split("-", each.value), 1)
  }
  subject {
    kind      = "Group"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
    namespace = element(split("-", each.value), 0)
  }
}

resource "aws_iam_role" "namespace" {
  for_each = local.namespace_types
  name     = "iam-role-eks-${each.value}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }]
    Version = "2012-10-17"
  })
}

data "aws_iam_policy_document" "namespace" {
  for_each = local.namespace_types
  version  = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole", ]
    resources = [aws_iam_role.namespace[each.key].arn, ]
  }
}

resource "aws_iam_policy" "namespace" {
  for_each = local.namespace_types
  name     = "iam-policy-eks-${each.value}"
  policy   = data.aws_iam_policy_document.namespace[each.key].json
}

resource "aws_iam_group" "namespace" {
  for_each = local.namespace_types
  name     = "iam-group-eks-${each.value}"
}

resource "aws_iam_group_policy_attachment" "namespace" {
  for_each   = local.namespace_types
  group      = aws_iam_group.namespace[each.key].name
  policy_arn = aws_iam_policy.namespace[each.key].arn
}

# aws-auth
locals {
  cluster_roles = [
    for key, role in aws_iam_role.cluster_access : {
      groups   = [join("-", slice(split("-", role.name), length(split("-", role.name)) - 2, length(split("-", role.name))))]
      rolearn  = role.arn
      username = join("-", slice(split("-", role.name), length(split("-", role.name)) - 2, length(split("-", role.name))))
    }
  ]
  namespace_roles = [
    for key, role in aws_iam_role.namespace : {
      groups   = [join("-", slice(split("-", role.name), length(split("-", role.name)) - 2, length(split("-", role.name))))]
      rolearn  = role.arn
      username = join("-", slice(split("-", role.name), length(split("-", role.name)) - 2, length(split("-", role.name))))
    }
  ]
}

data "template_file" "aws_auth" {
  template = file("${path.module}/templates/aws-auth.yaml.tpl")
  vars = {
    node_groups_role = aws_iam_role.iamRoleEksNodeGroup.arn
    cluster_roles    = indent(4, yamlencode(local.cluster_roles))
    namespace_roles  = indent(4, yamlencode(local.namespace_roles))
  }
}

resource "null_resource" "aws_auth" {
  triggers = {
    aws_auth = base64encode(data.template_file.aws_auth.rendered)
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.aws_auth.rendered}' | kubectl apply --insecure-skip-tls-verify=true --server='${aws_eks_cluster.eks.endpoint}' --token='${data.aws_eks_cluster_auth.eks.token}' -f -"
  }
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iamRoleEksCluster.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iamRoleEksCluster.name
}

# EKS Node Group
resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iamRoleEksNodeGroup.name
}
