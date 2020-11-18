variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
}

variable "azdo_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
}

variable "azdo_proj" {
  description = "Azure DevOps project for bootstrap repository"
  type        = string
}

variable "bootstrap_repo_name" {
  description = "Bootstrap repository name"
  type        = string
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      flux = object({
        enabled      = bool
        azdo_org     = string
        azdo_project = string
        azdo_repo    = string
      })
    })
  )
}

