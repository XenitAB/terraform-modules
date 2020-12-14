data "aws_iam_policy_document" "velero_s3_bucket" {
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

data "aws_iam_policy_document" "velero_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:velero:velero-server"
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

resource "aws_iam_policy" "velero" {
  name        = "${var.environment}-${data.aws_region.current.name}-${var.name}-velero"
  description = "A policy for velero in EKS"
  policy      = data.aws_iam_policy_document.velero_s3_bucket.json
}

resource "aws_iam_role" "velero" {
  name               = "${var.environment}-${data.aws_region.current.name}-${var.name}-velero"
  assume_role_policy = data.aws_iam_policy_document.velero_assume.json
}

resource "aws_iam_role_policy_attachment" "velero" {
  role       = aws_iam_role.velero.name
  policy_arn = aws_iam_policy.velero.arn
}
