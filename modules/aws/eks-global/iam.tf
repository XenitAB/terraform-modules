# EKS Admin
data "aws_iam_policy_document" "eks_admin_permission" {
  statement {
    effect = "Allow"
    actions = [
      "eks:*"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "eks_admin_assume" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
      type = "AWS"
    }
  }
}

resource "aws_iam_policy" "eks_admin" {
  name        = "iam-policy-eks-admin"
  description = "EKS Admin Role Plocy"
  policy      = data.aws_iam_policy_document.eks_admin_permission.json
}

resource "aws_iam_role" "eks_admin" {
  name               = "iam-role-eks-admin"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume.json
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

# EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-${data.aws_region.current.name}-${var.name}${var.eks_name_suffix}-cluster"

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
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# EKS Node Group
resource "aws_iam_role" "eks_node_group" {
  name = "${var.environment}-${data.aws_region.current.name}-${var.name}${var.eks_name_suffix}-node_group"

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

resource "aws_iam_role_policy_attachment" "container_registry_read_only" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
