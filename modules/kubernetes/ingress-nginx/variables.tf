variable "name_override" {
  description = "Name of ingress controller and ingress class"
  type        = string
  default     = ""
}

variable "cloud_provider" {
  description = "Cloud provider used for load balancer"
  type        = string
}

variable "internal_load_balancer" {
  description = "If true ingress controller will create a non public load balancer"
  type        = bool
  default     = false
}

variable "multiple_ingress" {
  description = "If true the cluster will support both private & public ingress"
  type        = bool
  default     = false
}

variable "default_ingress_class" {
  description = "If true the ingressClass defined will be the default one"
  type        = bool
  default     = false
}

variable "http_snippet" {
  description = "Configure helm ingress http-snippet"
  type        = string
  default     = ""
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
