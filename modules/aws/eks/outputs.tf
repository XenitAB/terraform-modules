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

output "prometheus_config" {
  description = "Configuration for Prometheus"
  value = {
    role_arn = module.prometheus.role_arn
  }
}

output "promtail_config" {
  description = "Configuration for Promtail"
  value = {
    role_arn = module.promtail.role_arn
  }
}

output "trivy_config" {
  description = "Configuration for Trivy"
  value = {
    trivy_operator_role_arn = module.trivy_operator_ecr["trivy"].role_arn
    trivy_role_arn          = module.trivy_ecr["trivy"].role_arn
  }
}

<<<<<<< HEAD
output "datadog_config" {
=======
output "datadog_iam" {
>>>>>>> 99dca23e (Update IAM for datadog)
  description = "Configuration for Datadog"
  value = {
    role_arn = module.datadog.role_arn
  }
}
