# Messaging

# WARNING!
# The policies below need to be updated to limit the
# scope of actions allowed and resources that are included.
data "aws_iam_policy_document" "iamPolicyDocumentMessaging" {
  statement {
    sid    = "AllowAllSNS"
    effect = "Allow"
    actions = [
      "sns:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowAllSQS"
    effect = "Allow"
    actions = [
      "sqs:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowAllSES"
    effect = "Allow"
    actions = [
      "ses:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "iamPolicyDocumentSaMessaging" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.openIDProviderEks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:common:*"
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

resource "aws_iam_policy" "iamPolicyMessaging" {
  name        = "iam-policy-eks-messaging"
  description = "A policy for messaging in EKS"

  policy = data.aws_iam_policy_document.iamPolicyDocumentMessaging.json
}

resource "aws_iam_role" "iamRoleSaMessaging" {
  assume_role_policy = data.aws_iam_policy_document.iamPolicyDocumentSaMessaging.json
  name               = "iam-role-eks-sa-messaging"
}

resource "aws_iam_role_policy_attachment" "iamRolePolicyAttachmentSaMessaging" {
  role       = aws_iam_role.iamRoleSaMessaging.name
  policy_arn = aws_iam_policy.iamPolicyMessaging.arn
}
