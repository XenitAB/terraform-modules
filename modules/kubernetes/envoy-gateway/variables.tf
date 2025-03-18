variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "envoy_gateway_config" {
  description = "Configuration for the username and password"
  type = object({
    logging_level             = optional(string, "info")
    replicas_count            = optional(number, 2)
    resources_memory_limit    = optional(string, "")
    resources_cpu_requests    = optional(string, "")
    resources_memory_requests = optional(string, "")
  })
  default = {}
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "tenant_namespaces" {
  description = "List of tenant namespaces"
  type        = list(string)
  default     = []
}