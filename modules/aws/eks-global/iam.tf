# EKS Admin
data "aws_iam_policy_document" "eks_admin_permission" {
  statement {
    effect = "Allow"
    actions = [
      "eks:*",
      "ec2:RunInstances",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DescribeVpcs",
      "ec2:DescribeTags",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeRouteTables",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteKeyPair",
      "ec2:CreateTags",
      "ec2:CreateSecurityGroup",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateKeyPair",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "iam:PassRole",
      "iam:ListRoles",
      "iam:ListRoleTags",
      "iam:ListInstanceProfilesForRole",
      "iam:ListInstanceProfiles",
      "iam:ListAttachedRolePolicies",
      "iam:GetRole",
      "iam:GetInstanceProfile",
      "iam:DetachRolePolicy",
      "iam:DeleteRole",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "kms:ListKeys",
      "kms:DescribeKey",
      "kms:CreateGrant",
    ]
    resources = [
      "*" #tfsec:ignore:AWS097
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
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_policy" "eks_admin" {
  name        = "eks-admin"
  description = "EKS Admin Role Plocy"
  policy      = data.aws_iam_policy_document.eks_admin_permission.json
}

resource "aws_iam_role" "eks_admin" {
  name               = "eks-admin"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume.json
  managed_policy_arns = [
    aws_iam_policy.eks_admin.arn,
  ]
}

# EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.name}-cluster"

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
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]
}

# EKS Node Group
resource "aws_iam_role" "eks_node_group" {
  name = "${var.name}-node-group"

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
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
}
