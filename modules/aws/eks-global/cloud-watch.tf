locals {
  eks_cluster1_name = "${var.environment}-${var.name}1"
  eks_cluster2_name = "${var.environment}-${var.name}2"
}

# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "eks1" {
  name              = "/aws/eks/${local.eks_cluster1_name}/cluster"
  retention_in_days = var.eks_cloudwatch_retention_period

  tags = local.global_tags
}

# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "eks2" {
  name              = "/aws/eks/${local.eks_cluster2_name}/cluster"
  retention_in_days = var.eks_cloudwatch_retention_period

  tags = local.global_tags
}
