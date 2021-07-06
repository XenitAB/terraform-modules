output "kube_config" {
  description = "Kube config for the created EKS cluster"
  sensitive   = true
  value = {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

/*
output "external_secrets_config" {
  description = "Configuration for External DNS"
  value = {
    role_arn = aws_iam_role.external_secrets.arn
  }
}

output "external_dns_config" {
  description = "Configuration for External DNS"
  value = {
    role_arn = aws_iam_role.external_dns.arn
  }
}

output "cert_manager_config" {
  description = "Configuration for Cert Manager"
  value = {
    role_arn = aws_iam_role.cert_manager.arn
  }
}

output "velero_config" {
  description = "Configuration for Velero"
  value = {
    role_arn     = aws_iam_role.velero.arn
    s3_bucket_id = var.velero_config.s3_bucket_id
  }
}
*/
