variable "github_org" {
  description = "Org of GitHub repositories"
  type        = string
}

variable "github_app_id" {
  description = "ID of GitHub Application used by Git Auth Proxy"
  type        = number
}

variable "github_installation_id" {
  description = "Installation ID of GitHub Application used by Git Auth Proxy"
  type        = number
}

variable "github_private_key" {
  description = "Private Key for GitHub Application used by Git Auth Proxy"
  type        = string
}

variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Environment name of the cluster"
  type        = string
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      flux = object({
        enabled = bool
        repo    = string
      })
    })
  )
}

variable "cluster_repo" {
  description = "Name of cluster repository"
  type        = string
  default     = "xks-fleet-infra"
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