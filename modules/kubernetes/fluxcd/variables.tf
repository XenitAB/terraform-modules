variable "environment" {
  description = "Environment name of the cluster."
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "providers" {
  description = "Git providers for repositories."
  type = map(object({
    organization = string
    github_orgs = optional(object({
      application_id  = number
      installation_id = number
      private_key     = string
    }))
    azure_devops_orgs = optional(object({
      pat = string
    }))
  }))
}

variable "bootstrap" {
  description = "Repository configuration to use for bootstrap."
  type = object({
    provider   = string
    project    = optional(string)
    repository = string
  })
}

variable "namespaces" {
  description = "Tenant namespaces to configure with Flux."
  type = list(
    object({
      name = string
      flux = optional(object({
        provider    = string
        project     = optional(string)
        repository  = string
        create_crds = bool
      }))
    })
  )
}
