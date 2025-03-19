variable "azure_key_vault_name" {
  description = "The name of the key vault where the root password for mongodb can be found"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "key_vault_resource_group_name" {
  description = "The resource group name where the core key vault is to be found"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}