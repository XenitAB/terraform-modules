variable "aad_groups" {
  description = "Configuration for Azure AD Groups (AAD Groups)"
  type = object({
    view = map(any)
    edit = map(any)
    cluster_admin = object({
      id   = string
      name = string
    })
    cluster_view = object({
      id   = string
      name = string
    })
    aks_managed_identity = object({
      id   = string
      name = string
    })
  })
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "customization" {
  description = "Global customization that will be applied to all ingress controllers."
  type = object({
    allow_snippet_annotations = bool
    http_snippet              = string
    extra_config              = map(string)
    extra_headers             = map(string)
  })
  default = {
    allow_snippet_annotations = false
    http_snippet              = ""
    extra_config              = {}
    extra_headers             = {}
  }
}

variable "customization_private" {
  description = "Private specific customization, will override the global customization."
  type = object({
    allow_snippet_annotations = optional(bool)
    http_snippet              = optional(string)
    extra_config              = optional(map(string))
    extra_headers             = optional(map(string))
  })
  default = {}
}

variable "datadog_enabled" {
  description = "Should datadog be enabled"
  type        = bool
  default     = false
}

variable "default_certificate" {
  description = "If enalbed and configured nginx will be configured with a default certificate."
  type = object({
    enabled  = bool,
    dns_zone = string,
  })
  default = {
    enabled  = false,
    dns_zone = "",
  }
}

variable "external_dns_hostname" {
  description = "Hostname for external-dns to use"
  type        = string
  default     = ""
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "min_replicas" {
  description = "The desired number of minimum replicas"
  type        = number
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name   = string
      labels = map(string)
      flux = optional(object({
        provider            = string
        project             = optional(string)
        repository          = string
        include_tenant_name = optional(bool, false)
        create_crds         = optional(bool, false)
      }))
    })
  )
}

variable "nginx_healthz_ingress_hostname" {
  description = "The hostname where we can reach the health endpoint"
  type        = string
}

variable "nginx_healthz_ingress_whitelist_ips" {
  description = "A comma separated string of ranges and or individual ips to be whitelisted for the healthz ingress"
  type        = string
  default     = ""
}

variable "private_ingress_enabled" {
  description = "If true will create a private ingress controller. Otherwise only a public ingress controller will be created."
  type        = bool
  default     = false
}

variable "replicas" {
  description = "The desired number of replicas"
  type        = number
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
