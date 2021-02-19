variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "owner_service_principal_name" {
  description = "The name of the service principal that will be used to run terraform and is owner of the subsciptions"
  type        = string
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groupss"
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

variable "partner_id" {
  description = "Azure partner id to link service principal with"
  type        = string
  default     = ""
}

variable "delegate_sub_groups" {
  description = "Should the subscription groups be delegated to global groups (example: az-sub-<subName>-all-owner)"
  type        = bool
  default     = true
}