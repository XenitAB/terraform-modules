variable "namespaces" {
  description = "Namespaces to apply mutating hooks to"
  type        = list(string)
}

variable "create_self_signed_cert" {
  description = "If true helm will generate a self signed cert"
  type        = bool
  default     = false
}
