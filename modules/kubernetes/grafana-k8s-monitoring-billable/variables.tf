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

variable "key_vault_rbac_enabled" {
  description = "If true, grant the grafana-k8s-monitoring-billable workload-identity user-assigned identity access to the Key Vault using an Azure RBAC role assignment (Key Vault Secrets User) instead of an access policy. Set this to true when the target Key Vault was created with `enable_rbac_authorization = true`."
  type        = bool
  default     = false
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
