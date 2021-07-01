resource "aws_eks_cluster" "this" {
  name     = "${var.name}${var.eks_name_suffix}-${var.environment}"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_config.kubernetes_version

  vpc_config {
    subnet_ids = [for s in aws_subnet.this : s.id]
  }

  tags = {
    Name        = "${var.name}${var.eks_name_suffix}-${var.environment}"
    Environment = var.environment
  }
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

resource "aws_eks_node_group" "this" {
  for_each = {
    for node_group in var.eks_config.node_groups :
    node_group.name => node_group
  }

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${aws_eks_cluster.this.name}-${each.value.name}"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  instance_types  = each.value.instance_types
  release_version = each.value.release_version
  scaling_config {
    desired_size = each.value.min_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  subnet_ids = [for s in data.aws_subnet.cluster : s.id]

  tags = {
    Name        = "${var.name}${var.eks_name_suffix}-${each.value.name}"
    Environment = var.environment
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
