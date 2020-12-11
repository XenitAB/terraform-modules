data "aws_iam_policy_document" "external_dns_route53" {
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

data "aws_iam_policy_document" "external_dns_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:external-dns:external-dns"
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

resource "aws_iam_policy" "external_dns" {
  name        = "${var.environment}-${var.region.location}-${var.name}-external-dns"
  description = "A policy for external-dns in EKS"
  policy = data.aws_iam_policy_document.external_dns_route53.json
}

resource "aws_iam_role" "external_dns" {
  name               = "${var.environment}-${var.region.location}-${var.name}-external-dns"
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume.json
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}
