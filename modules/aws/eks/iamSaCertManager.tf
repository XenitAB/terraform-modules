# cert manager
data "aws_iam_policy_document" "iamPolicyDocumentRoute53CertManager" {
  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange"
    ]
    resources = [
      "arn:aws:route53:::change/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "iamPolicyDocumentSaCertManager" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openIDProviderEks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:cert-manager:cert-manager"
      ]
    }

    principals {
      identifiers = [
        aws_iam_openid_connect_provider.openIDProviderEks.arn
      ]
      type = "Federated"
    }
  }
}

resource "aws_iam_policy" "iamPolicyCertManager" {
  name        = "iam-policy-eks-cert-manager"
  description = "A policy for cert-manager in EKS"

  policy = data.aws_iam_policy_document.iamPolicyDocumentRoute53CertManager.json
}

resource "aws_iam_role" "iamRoleSaCertManager" {
  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentSaCertManager.json
  name               = "iam-role-eks-sa-cert-manager"
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentSaCertManager" {
  role       = aws_iam_role.iamRoleSaCertManager.name
  policy_arn = aws_iam_policy.iamPolicyCertManager.arn
}
