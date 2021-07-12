variable "cloud_provider" {
  description = "Cloud provider to use"
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
  })
  default = {
    azure_key_vault_name = ""
    identity = {
      client_id = ""
      resource_id = ""
      tenant_id = ""
    }
  }
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

variable "thanos_receiver_fqdn" {
  description = "The thanos receiver fqdn"
  type        = string
}

variable "loki_api_fqdn" {
  description = "The loki api fqdn"
  type        = string
}
