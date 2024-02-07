variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "cluster_name" {
  description = "Name of the K8S cluster"
  type        = string
}

variable "environment" {
  description = "The environment in which the promtail instance is deployed"
  type        = string
}

variable "region" {
  description = "The region in which the promtail instance is deployed"
  type        = string
}

variable "excluded_namespaces" {
  description = "Namespaces to not ship logs from"
  type        = list(string)
  default     = []
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
