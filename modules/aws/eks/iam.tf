data "aws_iam_policy_document" "cert_manager" {
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
    resources = ["*"]
  }
}

module "cert_manager" {
  source = "../irsa"

  name                      = "cert-manager-${var.name}${var.eks_name_suffix}"
  oidc_urls                 = [aws_iam_openid_connect_provider.this.url]
  kubernetes_namespace      = "cert-manager"
  kubernetes_serviceaccount = "cert-manager"
  policy_json               = data.aws_iam_policy_document.cert_manager.json
}

data "aws_iam_policy_document" "external_dns" {
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

module "external_dns" {
  source = "../irsa"

  name                      = "external-dns-${var.name}${var.eks_name_suffix}"
  oidc_urls                 = [aws_iam_openid_connect_provider.this.url]
  kubernetes_namespace      = "external-dns"
  kubernetes_serviceaccount = "external-dns"
  policy_json               = data.aws_iam_policy_document.external_dns.json
}

data "aws_iam_policy_document" "velero" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = ["${var.velero_config.s3_bucket_arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [var.velero_config.s3_bucket_arn]
  }
}

module "velero" {
  source = "../irsa"

  name                      = "velero-${var.name}${var.eks_name_suffix}"
  oidc_urls                 = [aws_iam_openid_connect_provider.this.url]
  kubernetes_namespace      = "velero"
  kubernetes_serviceaccount = "velero"
  policy_json               = data.aws_iam_policy_document.cert_manager.json
}
