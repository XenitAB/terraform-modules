variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    subscription_id           = string,
    resource_group            = string,
    client_id                 = string,
    resource_id               = string,
    storage_account_name      = string,
    storage_account_container = string
  })
  default = {
    subscription_id           = ""
    tenant_id                 = ""
    resource_group            = ""
    client_id                 = ""
    resource_id               = ""
    storage_account_name      = ""
    storage_account_container = ""
  }
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
