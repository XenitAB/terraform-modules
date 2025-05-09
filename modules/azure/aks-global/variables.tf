variable "environment" {
  description = "The environemnt"
  type        = string
}

variable "location" {
  description = "The Azure region name"
  type        = string
}

variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "lock_resource_group" {
  description = "Lock the resource group for deletion"
  type        = bool
  default     = false
}

variable "dns_zone" {
  description = "List of DNS Zone to create"
  type        = list(string)
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "aks_group_name_prefix" {
  description = "Prefix for AKS Azure AD groups"
  type        = string
  default     = "aks"
}

variable "acr_name_override" {
  description = "Override default name of ACR"
  type        = string
  default     = ""
}

variable "acr_admin_enabled" {
  description = "If ACR admin account should be enabled"
  type        = bool
  default     = false
}
