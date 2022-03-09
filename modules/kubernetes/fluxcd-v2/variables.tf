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
      org  = string
      pat  = string
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
    org = string
    proj = string
    repo = string
  })
}

variable "namespaces" {
  description = "The namespaces to configure flux with"
  type = list(
    object({
      name = string
      create_crds = bool
      org         = string
      proj        = string
      repo        = string
    })
  )
}