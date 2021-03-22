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

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      flux = object({
        enabled = bool
        create_crds = bool
        org     = string
        proj    = string
        repo    = string
      })
    })
  )
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
