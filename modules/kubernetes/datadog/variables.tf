variable "datadog_site" {
  description = "Site to connect Datadog agent"
  type        = string
  default     = "datadoghq.eu"
}

variable "environment" {
  description = "Cluster environment"
  type        = string
}

variable "location" {
  description = "Cluster location"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "namespace_include" {
  description = "The namespace that should be checked by Datadog, example: kube_namespace:NAMESPACE kube_namespace:NAMESPACE2"
  type        = list(string)
}

variable "apm_ignore_resources" {
  description = "The resources that shall be excluded from APM"
  type        = list(string)
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
