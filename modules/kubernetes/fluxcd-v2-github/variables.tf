variable "github_owner" {
  description = "Owner of GitHub repositories"
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

variable "bootstrap_repo" {
  description = "Name of bootstrap repository"
  type        = string
  default     = "fleet-infra"
}

variable "branch" {
  description = "Branch to point source controller towards"
  type        = string
  default     = "main"
}

variable "repository_visibility" {
  description = "Visibility mode for created repositories"
  type        = string
  default     = "private"
}
