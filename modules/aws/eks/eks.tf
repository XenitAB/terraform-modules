resource "aws_iam_role" "eks" {
  name = "${var.environment}-${var.region.location}-${var.name}${var.eks_name_suffix}-cluster"

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

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role" "eks_node_group" {
  name = "${var.environment}-${var.region.location}-${var.name}${var.eks_name_suffix}-node_group"

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

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "container_registry_read_only" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-${var.name}${var.eks_name_suffix}"
  role_arn = aws_iam_role.eks.arn
  version  = var.eks_config.kubernetes_version

  vpc_config {
    subnet_ids = [for s in aws_subnet.this : s.id]
    #subnet_ids = [
    #  data.aws_subnet.subnet1.id,
    #  data.aws_subnet.subnet2.id,
    #  data.aws_subnet.subnet3.id
    #]
  }

  tags = {
    Name        = "${var.environment}-${var.name}${var.eks_name_suffix}"
    Environment = var.environment
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
  disk_size       = each.value.disk_size
  release_version = each.value.release_version
  scaling_config {
    desired_size = each.value.min_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  subnet_ids = [for s in aws_subnet.this : s.id]
  #subnet_ids = [
  #  data.aws_subnet.subnet1.id,
  #  data.aws_subnet.subnet2.id,
  #  data.aws_subnet.subnet3.id,
  #]

  tags = {
    Name        = "${var.environment}-${var.name}${var.eks_name_suffix}-${each.value.name}"
    Environment = var.environment
  }
}

data "tls_certificate" "thumbprint" {
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.thumbprint.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
