data "aws_iam_policy_document" "external_secrets_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:eks/wks/*"]
  }
}

data "aws_iam_policy_document" "external_secrets_assume" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:external-secrets:kubernetes-external-secrets"
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

resource "aws_iam_policy" "external_secrets" {
  name        = "${var.environment}-${var.region.location}-${var.name}-external-secrets"
  description = "A policy for external-secrets in EKS"
  policy = data.aws_iam_policy_document.external_secrets_secrets_manager.json
}

resource "aws_iam_role" "external_secrets" {
  name        = "${var.environment}-${var.region.location}-${var.name}-external-secrets"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume.json
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}

# Aggregate CRD permissions to edit cluster role
#resource "kubernetes_cluster_role" "externalsecrets_crd" {
#  metadata {
#    name = "aggregate-externalsecrets-edit"
#    labels = {
#      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
#    }
#  }
#
#  rule {
#    api_groups = ["kubernetes-client.io"]
#    resources  = ["externalsecrets"]
#    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
#  }
#}
