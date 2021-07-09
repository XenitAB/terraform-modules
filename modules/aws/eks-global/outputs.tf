output "eks_admin_role_arn" {
  description = "ARN for IAM role that should be used to create an EKS cluster"
  value       = aws_iam_role.eks_admin.arn
}

output "cluster_role_arn" {
  description = "EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_group_role_arn" {
  description = "EKS node grouop IAM role"
  value       = aws_iam_role.eks_node_group.arn
}

output "velero_config" {
  description = "ARN of velero s3 backup bucket"
  value = {
    s3_bucket_arn = aws_s3_bucket.velero.arn
    s3_bucket_id  = aws_s3_bucket.velero.id
  }
}

output "aws_kms_key_cmk" {
  description = "eks secrets customer master key"
  value       = aws_kms_key.this.arn
}

output "aad_groups" {
  description = "Azure AD groups"
  value       = local.aad_groups
}
