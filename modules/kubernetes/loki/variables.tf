variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "The storage account name"
  type        = string
  default     = ""
}

variable "storage_account_configuration" {
  description = "The storage account configuration"
  type = object({
    account_tier             = string
    account_replication_type = string
    account_kind             = string
  })
  default = {
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "StorageV2"
  }
}

variable "storage_container_name" {
  description = "The storage container name"
  type        = string
  default     = "loki"
}
