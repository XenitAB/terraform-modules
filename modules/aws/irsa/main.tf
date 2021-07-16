/**
  * # IRSA
  *
  * Creates IAM roles configured to work with EKS IRSA.
  * Configures the important trust polcies to allow Kubernetes Service Accounts
  * to assume the specific role.
  */

terraform {
  required_version = "0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}

data "aws_iam_policy_document" "assume" {
  dynamic "statement" {
    for_each = {
      for v in var.oidc_providers :
      v.arn => v
    }

    content {
      actions = [
        "sts:AssumeRoleWithWebIdentity"
      ]
      effect = "Allow"

      principals {
        identifiers = [
          statement.value.arn
        ]
        type = "Federated"
      }

      condition {
        test     = "StringEquals"
        variable = "${replace(statement.value.url, "https://", "")}:sub"
        values = [
          "system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"
        ]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_policy" "permissions" {
  name   = var.name
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "permissions" {
  policy_arn = aws_iam_policy.permissions.arn
  role       = aws_iam_role.this.name
}
