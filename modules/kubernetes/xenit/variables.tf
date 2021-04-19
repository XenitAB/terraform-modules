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
}

variable "thanos_receiver_fqdn" {
  description = "The thanos receiver fqdn"
  type        = string
}

variable "thanos_receiver_path" {
  description = "The thanos receiver fqdn"
  type        = string
  default     = "/"
}

variable "loki_api_fqdn" {
  description = "The loki api fqdn"
  type        = string
}

variable "loki_api_path" {
  description = "The loki api path"
  type        = string
  default     = "/"
}
