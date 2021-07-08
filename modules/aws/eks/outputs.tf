output "kube_config" {
  description = "Kube config for the created EKS cluster"
  sensitive   = true
  value = {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

output "cert_manager_config" {
  description = "Configuration for Cert Manager"
  value = {
    role_arn = module.cert_manager.role_arn
  }
}

output "external_dns_config" {
  description = "Configuration for External DNS"
  value = {
    role_arn = module.external_dns.role_arn
  }
}

output "velero_config" {
  description = "Configuration for Velero"
  value = {
    role_arn     = module.velero.role_arn
    s3_bucket_id = var.velero_config.s3_bucket_id
  }
}
