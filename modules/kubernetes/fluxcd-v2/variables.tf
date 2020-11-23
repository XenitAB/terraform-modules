variable "azdo_pat" {
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

variable "azdo_repo" {
  description = "Name of repository to bootstrap from"
  type        = string
  default     = "fleet-infra"
}

variable "git_path" {
  description = "Path to reconcile bootstrap from"
  type        = string
}

variable "branch" {
  description = "Path to reconcile bootstrap from"
  type        = string
  default = "master"
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

