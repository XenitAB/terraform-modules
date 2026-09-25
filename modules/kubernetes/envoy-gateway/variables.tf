variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "envoy_gateway_config" {
  description = "Configuration for the Envoy Gateway deployment"
  type = object({
    # Helm chart version for both gateway-helm and gateway-crds-helm
    chart_version = optional(string, "v1.7.2")

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

    # Image SHA256 digests for supply chain security. See more here matching matrix: https://gateway.envoyproxy.io/news/releases/matrix/
    # For the gateway controller image, we pin to the digest of the specific versioned image (e.g. v1.7.2) to ensure stability and security.
    # gateway:v1.7.2
    controller_image = optional(string, "docker.io/envoyproxy/gateway@sha256:a997e823dee831b38c1802fead055a71958e968195fc359bb63780abe799fb4f")
    # envoy:distroless-v1.37.2
    proxy_image = optional(string, "docker.io/envoyproxy/envoy@sha256:299a859d0cba5369a1070f96779399f2b491a6349bafaf7348babacfd1660d8d")
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

variable "default_gateway_config" {
  description = "Configuration for the default shared gateway."
  type = object({
    enabled           = optional(bool, false)
    wildcard_hostname = string
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