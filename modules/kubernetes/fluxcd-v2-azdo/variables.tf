variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
}

variable "azure_devops_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
}

variable "azure_devops_proj" {
  description = "Azure DevOps project for bootstrap repository"
  type        = string
}

variable "bootstrap_path" {
  description = "Path to reconcile bootstrap from"
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

variable "branch" {
  description = "Path to reconcile bootstrap from"
  type        = string
  default     = "master"
}

variable "bootstrap_repo" {
  description = "Name of repository to bootstrap from"
  type        = string
  default     = "fleet-infra"
}
