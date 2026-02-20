variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "envoy_gateway_config" {
  description = "Configuration for the username and password"
  type = object({
    logging_level             = optional(string, "info")
    replicas_count            = optional(number, 2)
    resources_memory_limit    = optional(string, "1Gi")
    resources_cpu_limit       = optional(string, "1000m")
    resources_cpu_requests    = optional(string, "100m")
    resources_memory_requests = optional(string, "256Mi")
    # Envoy Proxy (data plane) resources - these handle actual traffic
    proxy_cpu_limit       = optional(string, "2000m")
    proxy_memory_limit    = optional(string, "2Gi")
    proxy_cpu_requests    = optional(string, "200m")
    proxy_memory_requests = optional(string, "512Mi")
  })
  default = {}
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "healthz_config" {
  description = "Configuration for the health check endpoint exposed via the Envoy Gateway."
  type = object({
    hostname      = string
    whitelist_ips = optional(list(string), [])
  })
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}