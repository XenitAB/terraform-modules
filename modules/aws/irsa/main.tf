/**
  * # IRSA
  *
  * Creates IAM roles configured to work with EKS IRSA.
  * Configures the important trust polcies to allow Kubernetes Service Accounts
  * to assume the specific role.
  */

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
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
  for_each = {
    for s in ["policy-permission"] :
    s => s
    if var.policy_json != ""
  }
  name   = var.name
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "permissions" {
  for_each = {
    for s in ["policy-attachment"] :
    s => s
    if var.policy_json != ""
  }
  policy_arn = aws_iam_policy.permissions["policy-permission"].arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "policy_permissions" {
  for_each   = var.policy_permissions_arn
  policy_arn = each.value
  role       = aws_iam_role.this.name
}
