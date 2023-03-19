variable "resource_name_overrides" {
  description = "A way to override the resource names"
  type = object({
    azuread_group_rg = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azuread_group_sub = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azuread_group_all_subs = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azuread_group_acr = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azuread_application_rg = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azuread_application_sub = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azurerm_resource_group = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
    azurerm_key_vault = optional(object({
      prefixes = optional(list(string))
      suffixes = optional(list(string))
    }))
  })
  default = null
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groups"
  type        = string
  default     = "az"
}

variable "aks_group_name_prefix" {
  description = "Prefix for AKS Azure AD groups"
  type        = string
  default     = "aks"
}

variable "service_principal_name_prefix" {
  description = "Prefix for service principals"
  type        = string
  default     = "sp"
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
  default     = null
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
  default     = null
}

variable "location_short" {
  description = "The location shortname for the subscription"
  type        = string
  default     = null
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = null
}
