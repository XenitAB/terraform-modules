variable "prometheus_enabled" {
  description = "Should a ServiceMonitor be created"
  type        = bool
  default     = false
}

variable "http_snippet" {
  description = "Configure helm ingress http-snippet"
  type        = string
  default     = ""
}
