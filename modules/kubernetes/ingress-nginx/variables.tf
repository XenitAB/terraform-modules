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

variable "http_snippet" {
  description = "Configure helm ingress http-snippet"
  type        = string
  default     = ""
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}