variable "aks_cluster_id" {
  description = "AKS cluster id."
  type        = string
}

variable "argocd_config" {
  description = "ArgoCD configuration"
  type = object({
    aad_group_name                  = optional(string, "az-sub-xks-all-owner")
    cluster_role                    = optional(string, "Spoke")
    application_set_replicas        = optional(number, 2)
    controller_replicas             = optional(number, 3)
    repo_server_replicas            = optional(number, 2)
    server_replicas                 = optional(number, 2)
    dynamic_sharding                = optional(bool, false)
    controller_status_processors    = optional(number, 50)
    controller_operation_processors = optional(number, 100)
    argocd_k8s_client_qps           = optional(number, 150)
    argocd_k8s_client_burst         = optional(number, 300)
    redis_enabled                   = optional(bool, true)
    global_domain                   = optional(string, "")
    ingress_whitelist_ip            = optional(string, "")
    dex_tenant_name                 = optional(string, "")
    dex_redirect_domains            = optional(string, "")
    oidc_issuer_url                 = optional(map(string), {})
    sync_windows = optional(list(object({
      kind        = string
      schedule    = string
      duration    = string
      manual_sync = optional(bool, true)
    })), [])
    azure_tenants = optional(list(object({
      tenant_name = string
      tenant_id   = string
      clusters = list(object({
        name            = string
        api_server      = string
        environment     = string
        azure_client_id = optional(string, "")
        ca_data         = optional(string, "")
        tenants = list(object({
          # This will be used to only if cluster_role is set to 'Hub-Spoke' to create AppProject 
          # roles that limit access to the project, based on the AAD group we create for each 
          # tenant namespace.
          aad_group              = optional(string, "")
          name                   = string
          namespace              = string
          repo_url               = string
          repo_path              = string
          github_app_id          = string
          github_installation_id = string
          secret_name            = string

        }))
      }))
    })), [])
  })
  default = {}

  validation {
    condition     = contains(["Hub", "Spoke", "Hub-Spoke"], var.argocd_config.cluster_role)
    error_message = "Invalid cluster role: ${var.argocd_config.cluster_role}. Allowed vallues: ['Hub', 'Spoke', 'Hub-Spoke']"
  }
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "core_resource_group_name" {
  description = "The Azure core resource group name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra config"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "key_vault_name" {
  description = "The Azure core key vault name"
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

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}