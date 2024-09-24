variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
  sensitive   = true
}

variable "azure_devops_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
}

variable "azure_devops_proj" {
  description = "Azure DevOps project for bootstrap repository"
  type        = string
}

variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      flux = object({
        enabled             = bool
        create_crds         = bool
        include_tenant_name = bool
        org                 = string
        proj                = string
        repo                = string
      })
    })
  )
  default = [{
    name = ""
    flux = {
      enabled             = true
      create_crds         = false
      include_tenant_name = false
      org                 = ""
      proj                = ""
      repo                = ""
    }
    }
  ]
}

variable "cluster_repo" {
  description = "Name of cluster repository"
  type        = string
  default     = "fleet-infra"
}

variable "branch" {
  description = "Branch to point source controller towards"
  type        = string
  default     = "main"
}
variable "slack_flux_alert_config" {
  description = "A webhook address for sending alerts to slack"
  type = object({
    xenit_webhook  = string
    tenant_webhook = string

  })
  default = {
    xenit_webhook  = ""
    tenant_webhook = ""
  }
}