variable "xenit_config" {
  description = "Xenit Platform configuration"
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

variable "loki_api_fqdn" {
  description = "The loki api fqdn"
  type        = string
}
