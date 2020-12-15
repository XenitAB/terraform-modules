data "aws_iam_policy_document" "cert_manager_route53" {
  statement {
    sid    = "AllowRoute53Change"
    effect = "Allow"
    actions = [
      "route53:GetChange"
    ]
    resources = ["arn:aws:route53:::change/*"]
  }
  statement {
    sid    = "AllowRoute53Record"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    sid    = "AllowRoute53List"
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = ["arn:aws:route53:::*"]
  }
}

data "aws_iam_policy_document" "cert_manager_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:cert-manager:cert-manager"
      ]
    }

    principals {
      identifiers = [
        aws_iam_openid_connect_provider.this.arn
      ]
      type = "Federated"
    }
  }
}

resource "aws_iam_policy" "cert_manager" {
  name        = "${var.environment}-${data.aws_region.current.name}-${var.name}-cert-manager"
  description = "A policy for cert-manager in EKS"
  policy      = data.aws_iam_policy_document.cert_manager_route53.json
}

resource "aws_iam_role" "cert_manager" {
  name               = "${var.environment}-${data.aws_region.current.name}-${var.name}-cert-manager-dns"
  assume_role_policy = data.aws_iam_policy_document.cert_manager_assume.json
}

resource "aws_iam_role_policy_attachment" "cert_manager" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = aws_iam_policy.cert_manager.arn
}
