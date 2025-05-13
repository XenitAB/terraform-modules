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
    type         = optional(string, "azuredevops")
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

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "aks_name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "acr_name_override" {
  description = "Override default name of ACR"
  type        = string
  default     = ""
}

variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}
