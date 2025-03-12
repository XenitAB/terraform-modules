variable "aks_cluster_id" {
  description = "AKS cluster id."
  type        = string
}

variable "argocd_config" {
  description = "ArgoCD configuration"
  type = object({
    aad_group_name           = optional(string, "az-sub-xks-all-owner")
    application_set_replicas = optional(number, 2)
    controller_min_replicas  = optional(number, 1)
    repo_server_min_replicas = optional(number, 2)
    server_min_replicas      = optional(number, 2)
    redis_enabled            = optional(bool, true)
    global_domain            = optional(string, "")
    ingress_whitelist_ip     = optional(string, "")
    tenant_name              = optional(string, "")
    oidc_issuer_url          = optional(string, "")
    clusters = optional(list(object({
      name            = string
      api_server      = string
      environment     = string
      azure_client_id = string
      azure_tenant_id = string
      ca_data         = string
      tenants = optional(list(object({
        namespace   = string
        repo_url    = string
        repo_path   = string
        secret_name = string
      })), [])
    })), [])
  })
  default = {}
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "core_resource_group_name" {
  description = "The Azure core resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "key_vault_name" {
  description = "The Azure core key vault name"
  type        = string
}