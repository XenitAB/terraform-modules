locals {
  eks_cluster1_name = "${var.environment}-${var.name}1"
  eks_cluster2_name = "${var.environment}-${var.name}2"
}

resource "aws_kms_key" "eks_cluster_logs" {
  description             = "EKS Cluster Logs"
  deletion_window_in_days = 10
}

resource "aws_cloudwatch_log_group" "eks1" {
  name              = "/aws/eks/${local.eks_cluster1_name}/cluster"
  retention_in_days = var.eks_cloudwatch_retention_period
  kms_key_id = aws_kms_key.eks_cluster_logs.arn

  tags = local.global_tags
}

resource "aws_cloudwatch_log_group" "eks2" {
  name              = "/aws/eks/${local.eks_cluster2_name}/cluster"
  retention_in_days = var.eks_cloudwatch_retention_period
  kms_key_id = aws_kms_key.eks_cluster_logs.arn

  tags = local.global_tags
}
