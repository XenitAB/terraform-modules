output "kube_config" {
  description = "Kube config for the created EKS cluster"
  sensitive   = true
  value = {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token

    # Ugly workaround to force the addons to be installed before starting with the core module
    dummy_data = {
      core_dns      = aws_eks_addon.core_dns
      aws_eks_addon = aws_eks_addon.kube_proxy
    }
  }
}

output "cluster_autoscaler_config" {
  description = "Configuration for Cluster Autoscaler"
  value = {
    role_arn = module.cluster_autoscaler.role_arn
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

output "xenit_config" {
  description = "Configuration for Xenit proxy"
  value = {
    role_arn = module.xenit.role_arn
  }
}
