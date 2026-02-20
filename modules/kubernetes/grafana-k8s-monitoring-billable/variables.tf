variable "azure_key_vault_name" {
  description = "Name of the Azure Key Vault containing Grafana Cloud secrets"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster (used as label in Grafana Cloud)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infrastructure configuration"
  type = object({
    argocd_project_name = string
    git_repo_url        = string
    k8s_api_server_url  = string
  })
}

variable "key_vault_id" {
  description = "ID of the Azure Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "tenant_name" {
  description = "Tenant name"
  type        = string
}
