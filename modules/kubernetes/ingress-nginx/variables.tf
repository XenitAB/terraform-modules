variable "cloud_provider" {
  description = "Cloud provider used for load balancer"
  type        = string
}

variable "http_snippet" {
  description = "Configure helm ingress http-snippet"
  type        = string
  default     = ""
}

variable "public_private_enabled" {
  description = "Should ingress controllers for both public and private be created?"
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

variable "extra_config" {
  description = "Extra config to add to Ingress NGINX"
  type        = map(string)
  default     = {}
}

variable "extra_headers" {
  description = "Addtional headers to be added"
  type        = map(string)
  default     = {}
}
