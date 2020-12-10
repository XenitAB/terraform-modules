variable "notification_email" {
  description = "Email address to send certificate expiration notifications"
  type        = string
}

variable "acme_server" {
  description = "ACME server to add to the created ClusterIssuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}