data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

module "cluster_autoscaler" {
  source = "../irsa"

  name = "${data.aws_region.current.name}-${var.environment}-cluster-autoscaler-${var.name}${var.eks_name_suffix}"
  oidc_providers = [
    {
      url = aws_iam_openid_connect_provider.this.url
      arn = aws_iam_openid_connect_provider.this.arn
    }
  ]
  kubernetes_namespace       = "cluster-autoscaler"
  kubernetes_service_account = "cluster-autoscaler"
  policy_json                = data.aws_iam_policy_document.cluster_autoscaler.json
}

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

  name = "${data.aws_region.current.name}-${var.environment}-cert-manager-${var.name}${var.eks_name_suffix}"
  oidc_providers = [
    {
      url = aws_iam_openid_connect_provider.this.url
      arn = aws_iam_openid_connect_provider.this.arn
    }
  ]
  kubernetes_namespace       = "cert-manager"
  kubernetes_service_account = "cert-manager"
  policy_json                = data.aws_iam_policy_document.cert_manager.json
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

  name = "${data.aws_region.current.name}-${var.environment}-external-dns-${var.name}${var.eks_name_suffix}"
  oidc_providers = [
    {
      url = aws_iam_openid_connect_provider.this.url
      arn = aws_iam_openid_connect_provider.this.arn
    }
  ]
  kubernetes_namespace       = "external-dns"
  kubernetes_service_account = "external-dns"
  policy_json                = data.aws_iam_policy_document.external_dns.json
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

  name = "${data.aws_region.current.name}-${var.environment}-velero-${var.name}${var.eks_name_suffix}"
  oidc_providers = [
    {
      url = aws_iam_openid_connect_provider.this.url
      arn = aws_iam_openid_connect_provider.this.arn
    }
  ]
  kubernetes_namespace       = "velero"
  kubernetes_service_account = "velero"
  policy_json                = data.aws_iam_policy_document.velero.json
}

data "aws_iam_policy_document" "xenit" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/xenit-proxy-certificate-*"]
  }
}

module "xenit" {
  source = "../irsa"

  name = "${data.aws_region.current.name}-${var.environment}-xenit-${var.name}${var.eks_name_suffix}"
  oidc_providers = [
    {
      url = aws_iam_openid_connect_provider.this.url
      arn = aws_iam_openid_connect_provider.this.arn
    }
  ]
  kubernetes_namespace       = "xenit-system"
  kubernetes_service_account = "xenit-proxy"
  policy_json                = data.aws_iam_policy_document.xenit.json
}
