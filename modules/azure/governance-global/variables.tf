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

variable "partner_id" {
  description = "Azure partner id to link service principal with"
  type        = string
  default     = ""
}

variable "delegate_sub_groups" {
  description = "Should the subscription groups be delegated to global groups (example: az-sub-[subName]-all-owner)"
  type        = bool
  default     = true
}

variable "delegate_acr" {
  description = "Should Azure Container Registry delegation be configured?"
  type        = bool
  default     = true
}

variable "resource_group_configs" {
  description = "Resource group configuration"
  type = list(
    object({
      common_name                = string
      delegate_aks               = bool # Delegate aks permissions
      delegate_key_vault         = bool # Delegate KeyVault creation
      delegate_service_endpoint  = bool # Delegate Service Endpoint permissions
      delegate_service_principal = bool # Delegate Service Principal
      disable_unique_suffix      = bool # Disable unique_suffix on resource names
      tags                       = map(string)
    })
  )
}

variable "resource_name_overrides" {
  description = "A way to override the resource names"
  type        = any
  default     = null
}

variable "service_principal_all_owner_name" {
  description = "Name of the manually created SP-sub-all-owner"
  type        = string
}
