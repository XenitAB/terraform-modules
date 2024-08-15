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

variable "private_ingress_enabled" {
  description = "If true will create a private ingress controller. Otherwise only a public ingress controller will be created."
  type        = bool
  default     = false
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

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}

variable "datadog_enabled" {
  description = "Should datadog be enabled"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
