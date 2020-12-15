variable "excluded_namespaces" {
  description = "Namespaces to exclude from mutating hooks"
  type        = list(string)
}

variable "create_self_signed_cert" {
  description = "If true helm will generate a self signed cert"
  type        = bool
  default     = false
}
