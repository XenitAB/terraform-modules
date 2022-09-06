# EKS Encrytion
resource "aws_kms_key" "eks_encryption" {
  description         = "Used for EKS secret encryption"
  enable_key_rotation = true

  tags = merge(
    local.global_tags,
    {
      Name = "EKS Encrytion"
    },
  )
}

# EKS Admin
data "aws_iam_policy_document" "eks_admin_permission" {
  statement {
    effect = "Allow"
    #tfsec:ignore:AWS099
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
      "iam:CreateServiceLinkedRole",
      "iam:AttachRolePolicy",
      "kms:ListKeys",
      "kms:DescribeKey",
      "kms:CreateGrant",
    ]
    #tfsec:ignore:AWS099
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
      type        = "AWS"
      identifiers = var.eks_admin_assume_principal_ids
    }
  }
}

resource "aws_iam_policy" "eks_admin" {
  name        = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-admin"
  description = "EKS Admin Role Plocy"
  policy      = data.aws_iam_policy_document.eks_admin_permission.json

  tags = local.global_tags
}

resource "aws_iam_role" "eks_admin" {
  name               = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-admin"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume.json
  managed_policy_arns = [
    aws_iam_policy.eks_admin.arn,
  ]

  tags = local.global_tags
}

# EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-cluster"

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

  tags = local.global_tags
}

# EKS Node Group
resource "aws_iam_role" "eks_node_group" {
  name = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-node-group"

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

  tags = local.global_tags
}


# EBS CSI controller
resource "aws_iam_role" "eks_ebs_csi" {
  name = "${var.name_prefix}-${data.aws_region.current.name}-${var.environment}-${var.name}-ebs-csi"

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
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
  ]

  tags = local.global_tags
}
