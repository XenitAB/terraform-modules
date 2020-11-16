variable "regions" {
  description = "The Azure Regions to configure"
  type = list(object({
    location       = string
    location_short = string
  }))
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
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
      tags                       = map(string)
    })
  )
}

variable "owner_service_principal_name" {
  description = "The name of the service principal that will be used to run terraform and is owner of the subsciptions"
  type        = string
}
