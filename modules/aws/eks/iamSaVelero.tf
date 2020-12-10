# External DNS
data "aws_iam_policy_document" "iamPolicyDocumentS3BucketVelero" {
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
    resources = ["${aws_s3_bucket.s3BucketVelero.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"

    ]
    resources = ["${aws_s3_bucket.s3BucketVelero.arn}"]
  }
}

data "aws_iam_policy_document" "iamPolicyDocumentSaVelero" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.openIDProviderEks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:velero:velero-server"
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

resource "aws_iam_policy" "iamPolicyVelero" {
  name        = "iam-policy-eks-velero"
  description = "A policy for velero in EKS"

  policy = data.aws_iam_policy_document.iamPolicyDocumentS3BucketVelero.json
}

resource "aws_iam_role" "iamRoleSaVelero" {
  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentSaVelero.json
  name               = "iam-role-eks-sa-velero"
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentSaVelero" {
  role       = aws_iam_role.iamRoleSaVelero.name
  policy_arn = aws_iam_policy.iamPolicyVelero.arn
}
