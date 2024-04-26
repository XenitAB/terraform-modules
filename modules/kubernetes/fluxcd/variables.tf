variable "environment" {
  description = "Environment name of the cluster."
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "git_provider" {
  description = "Git provider for repositories."
  type = object({
    organization = string
    github = optional(object({
      application_id  = number
      installation_id = number
      private_key     = string
    }))
    azure_devops = optional(object({
      pat = string
    }))
  })
}

variable "bootstrap" {
  description = "Repository configuration to use for bootstrap."
  type = object({
    project    = optional(string)
    repository = string
  })
}

variable "namespaces" {
  description = "Flux tenants to add."
  type = list(
    object({
      name                = string
      include_tenant_name = bool
      flux = optional(object({
        project     = optional(string)
        repository  = string
        create_crds = bool
      }))
    })
  )
}
