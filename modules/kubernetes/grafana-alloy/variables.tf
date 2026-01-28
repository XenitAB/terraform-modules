variable "aks_name" {
  description = "The AKS cluster short name, e.g. 'aks'."
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration for Key Vault access"
  type = object({
    azure_key_vault_name = string
    keyvault_secret_name = string
  })
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "extra_namespaces" {
  type        = list(string)
  description = "List of namespaces that should be enabled"
  default     = ["ingress-nginx"]
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "include_kubelet_metrics" {
  description = "If kubelet metrics shall be included for the namespaces in 'namespace_include'"
  type        = bool
  default     = false
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "namespace_include" {
  description = "A list of the namespaces that kube-state-metrics and kubelet metrics"
  type        = list(string)
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "remote_write_urls" {
  description = "The remote write urls"
  type = object({
    metrics = string
    logs    = string
    traces  = string
  })
  default = {
    metrics = ""
    logs    = ""
    traces  = ""
  }
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
