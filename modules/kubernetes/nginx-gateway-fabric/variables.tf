variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "gateway_config" {
  description = "Gateway Fabric configuration"
  type = object({
    logging_level     = optional(string, "info")
    replica_count     = optional(number, 2)
    telemetry_enabled = optional(bool, true)
    telemetry_config = optional(object({
      endpoint    = optional(string, "")
      interval    = optional(string, "")
      batch_size  = optional(number, 0)
      batch_count = optional(number, 0)
    }), {})
  })
}

variable "nginx_config" {
  description = "Global nginx configuration that will be applied to GatewayClass."
  type = object({
    allow_snippet_annotations = optional(bool, false)
    http_snippet              = optional(string, "")
    extra_config              = optional(map(string), {})
    extra_headers             = optional(map(string), {})
  })
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}