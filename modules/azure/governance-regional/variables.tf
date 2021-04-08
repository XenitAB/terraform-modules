variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "location" {
  description = "The location for the subscription"
  type        = string
}

variable "location_short" {
  description = "The location shortname for the subscription"
  type        = string
}

variable "owner_service_principal_name" {
  description = "The name of the service principal that will be used to run terraform and is owner of the subsciptions"
  type        = string
}

variable "core_name" {
  description = "The commonName for the core infra"
  type        = string
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
      lock_resource_group        = bool # Adds management_lock (CanNotDelete) to the resource group
      tags                       = map(string)
    })
  )
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "partner_id" {
  description = "Azure partner id to link service principal with"
  type        = string
  default     = ""
}

variable "key_vault_purge_protection_enabled" {
  description = "If true purge protection will be enabled to all key vaults"
  type        = bool
  default     = false
}

variable "azuread_groups" {
  description = "Azure AD groups from global"
  type = object({
    rg_owner = map(object({
      id = string
    }))
    rg_contributor = map(object({
      id = string
    }))
    rg_reader = map(object({
      id = string
    }))
    sub_owner = object({
      id = string
    })
    sub_contributor = object({
      id = string
    })
    sub_reader = object({
      id = string
    })
    service_endpoint_join = object({
      id = string
    })
  })
}

variable "azuread_apps" {
  description = "Azure AD applications from global"
  type = object({
    delegate_kv = map(object({
      display_name                = string
      application_object_id       = string
      application_id              = string
      service_principal_object_id = string
    }))
    rg_contributor = map(object({
      display_name                = string
      application_object_id       = string
      application_id              = string
      service_principal_object_id = string
    }))
    sub_reader = object({
      display_name                = string
      application_object_id       = string
      application_id              = string
      service_principal_object_id = string
    })
  })
}
