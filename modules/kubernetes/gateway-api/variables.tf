variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "gateway_api_config" {
  description = "The Gateway API configuration"
  type = object({
    api_version       = optional(string, "v1.2.0")
    api_channel       = optional(string, "standard")
    gateway_name      = optional(string, "")
    gateway_namespace = optional(string, "")
  })
  default = {}

  validation {
    condition     = contains(["standard", "experimental"], var.gateway_api_config.api_channel)
    error_message = "Invalid API channel: ${var.gateway_api_config.api_channel}. Allowed vallues: ['standard', 'experimental']"
  }
}