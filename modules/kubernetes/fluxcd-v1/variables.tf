variable "azure_devops_domain" {
  description = "Domain for azure devops"
  type        = string
  default     = "dev.azure.com"
}

variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
}

variable "azure_devops_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
}

variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "branch" {
  description = "The branch to reconcile manifests from"
  type        = string
  default     = "main"
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      flux = object({
        enabled = bool
        azure_devops = object({
          org  = string
          proj = string
          repo = string
        })
      })
    })
  )
}

variable "flux_status_enabled" {
  description = "Should flux status be enabled?"
  type        = bool
  default     = false
}
