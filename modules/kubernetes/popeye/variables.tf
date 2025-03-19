variable "aks_managed_identity_id" {
  description = "The principal id of the AKS managed identity"
  type        = string
}

variable "cluster_id" {
  description = "The AKS cluster id"
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

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "oidc_issuer_url" {
  description = "The AKS token exchange URL"
  type        = string
}

variable "popeye_config" {
  description = "The popeye configuration"
  type = object({
    allowed_registries = optional(list(string), [])
    cron_jobs = optional(list(object({
      namespace     = optional(string, "default")
      resources     = optional(string, "cj,cm,deploy,ds,gw,gwc,gwr,hpa,ing,job,np,pdb,po,pv,pvc,ro,rb,sa,sec,sts,svc")
      output_format = optional(string, "html")
      schedule      = optional(string, "0 0 * * 1")
    })), [{}])
    storage_account = optional(object({
      resource_group_name = optional(string, "")
      account_name        = optional(string, "")
      file_share_size     = optional(string, "1Gi")
    }), {})
  })
  default = {}
}

variable "resource_group_name" {
  description = "The Azure AKS resource group name"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}