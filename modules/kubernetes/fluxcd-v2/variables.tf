<<<<<<< HEAD
variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "credentials" {
  description = "List of credentials for Git Providers."
  type = list(object({
    type = string # azuredevops or github
    azure_devops = object({
      org = string
      pat = string
    })
    github = object({
      org             = string
      app_id          = number
      installation_id = number
      private_key     = string
    })
  }))
}

variable "fleet_infra" {
  description = "Configuration for Flux bootstrap repository."
  type = object({
    type = string
    org  = string
    proj = string
    repo = string
  })
=======
variable "azure_devops_pat" {
  description = "PAT to authenticate with Azure DevOps"
  type        = string
  sensitive   = true
  default     = "null"
}

variable "azure_devops_org" {
  description = "Azure DevOps organization for bootstrap repository"
  type        = string
  default     = "null"
}

variable "azure_devops_proj" {
  description = "Azure DevOps project for bootstrap repository"
  type        = string
  default     = "null"
}

variable "github_org" {
  description = "Org of GitHub repositories"
  type        = string
  default     = "null"
}

variable "github_app_id" {
  description = "ID of GitHub Application used by Git Auth Proxy"
  type        = number
  default     = "null"
}

variable "github_installation_id" {
  description = "Installation ID of GitHub Application used by Git Auth Proxy"
  type        = number
  default     = "null"
}

variable "github_private_key" {
  description = "Private Key for GitHub Application used by Git Auth Proxy"
  type        = string
  default     = "null"
}

variable "environment" {
  description = "Environment name of the cluster"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
>>>>>>> Add initial config
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
<<<<<<< HEAD
      name        = string
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
}
=======
      name = string
      flux = object({
        enabled     = bool
        create_crds = bool
        org         = string
        proj        = string
        repo        = string
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
>>>>>>> Add initial config
