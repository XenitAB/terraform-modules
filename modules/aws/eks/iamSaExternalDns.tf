# External DNS
data "aws_iam_policy_document" "iamPolicyDocumentRoute53ExternalDns" {
  statement {
    sid    = "AllowRoute53Change"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    sid    = "AllowRoute53List"
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "iamPolicyDocumentSaExternalDns" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openIDProviderEks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:external-dns:external-dns"
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

resource "aws_iam_policy" "iamPolicyExternalDns" {
  name        = "iam-policy-eks-external-dns"
  description = "A policy for external-dns in EKS"

  policy = data.aws_iam_policy_document.iamPolicyDocumentRoute53ExternalDns.json
}

resource "aws_iam_role" "iamRoleSaExternalDns" {
  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentSaExternalDns.json
  name               = "iam-role-eks-sa-external-dns"
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentSaExternalDns" {
  role       = aws_iam_role.iamRoleSaExternalDns.name
  policy_arn = aws_iam_policy.iamPolicyExternalDns.arn
}
