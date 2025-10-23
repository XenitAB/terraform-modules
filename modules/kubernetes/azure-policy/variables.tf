variable "aks_name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "aks_name_suffix" {
  description = "The suffix for the aks clusters"
  type        = number
}

variable "azure_policy_config" {
  description = "A list of Azure policy mutations to create and include in the XKS policy set definition"
  type = object({
    exclude_namespaces = list(string)
    mutations = list(object({
      name         = string
      display_name = string
      template     = string
    }))
  })
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "tenant_namespaces" {
  description = "List of tenant namespaces for Flux"
  type        = list(string)
  default     = []
}
