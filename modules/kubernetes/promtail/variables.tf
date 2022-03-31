variable "cloud_provider" {
  description = "Name of cloud provider"
  type        = string
}


variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn = string
  })
  default = {
    role_arn = ""
  }
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
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
  }
}

variable "loki_address" {
  description = "The address of the Loki instance to send logs to"
  type        = string
}
