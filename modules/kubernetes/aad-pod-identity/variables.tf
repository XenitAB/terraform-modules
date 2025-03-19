variable "aad_pod_identity" {
  description = "Configuration for aad pod identity"
  type = map(object({
    id        = string
    client_id = string
  }))
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

variable "namespaces" {
  description = "Namespaces to create AzureIdentity and AzureIdentityBindings in."
  type = list(
    object({
      name = string
    })
  )
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
