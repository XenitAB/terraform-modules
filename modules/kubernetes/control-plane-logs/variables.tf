variable "cloud_provider" {
  description = "Name of cloud provider"
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
    identity = object({
      client_id   = string
      resource_id = string
      tenant_id   = string
    })
    eventhub_hostname = string
    eventhub_name     = string
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
    eventhub_hostname = ""
    eventhub_name     = ""
  }
}
