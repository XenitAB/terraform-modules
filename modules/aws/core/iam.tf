# EKS Admin Role
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_admin_permission" {
  statement {
    effect = "Allow"
    actions = [
      "*"
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

  policy = data.aws_iam_policy_document.iamPolicyDocumentEksAdminPermission.json
}

resource "aws_iam_role" "eks_admin" {
  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentEksAdminAssume.json
  name               = "iam-role-eks-admin"
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.iamRoleEksAdmin.name
  policy_arn = aws_iam_policy.iamPolicyEksAdmin.arn
}
