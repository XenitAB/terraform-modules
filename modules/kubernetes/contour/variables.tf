variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

/*variable "contour_config" {
  description = "Contour configuration"
  type = object({
    ingress_enabled = optional(bool, true)
    replica_count   = optional(number, 2)
    resource_preset = optional(string, "small")
  })
}

variable "envoy_config" {
  description = "Contour configuration"
  type = object({
    log_level       = optional(string, "info")
    replica_count   = optional(number, 2)
    resource_preset = optional(string, "small")
    hpa_enabled     = optional(bool, false)
    hpa_config = optional(object({
      max_replicas  = number
      maz_cpu       = optional(string, null)
      target_memory = optional(string, null)
      behavior      = optional(string, null)
    }))
  })
}
*/