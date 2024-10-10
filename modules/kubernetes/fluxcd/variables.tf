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
    organization        = string
    type                = optional(string, "azuredevops")
    include_tenant_name = optional(bool, false)
    github = optional(object({
      application_id  = number
      installation_id = number
      private_key     = string
    }))
    azure_devops = optional(object({
      pat = string
    }))
  })

  validation {
    condition     = contains(["github", "azuredevops"], var.git_provider.type)
    error_message = "Invalid provider type: ${var.git_provider.type}. Allowed vallues: ['github', 'azuredevops']"
  }
}

variable "bootstrap" {
  description = "Repository configuration to use for bootstrap."
  type = object({
    disable_secret_creation = optional(bool, true)
    project                 = optional(string)
    repository              = string
  })
}

variable "namespaces" {
  description = "Flux tenants to add."
  type = list(
    object({
      name   = string
      labels = optional(map(string), null)
      fluxcd = optional(object({
        provider            = string
        project             = optional(string)
        repository          = string
        include_tenant_name = optional(bool, false)
        create_crds         = optional(bool, true)
      }))
    })
  )
  default = []
}
