variable "github_owner" {
  description = "Owner of GitHub repositories"
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

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}
