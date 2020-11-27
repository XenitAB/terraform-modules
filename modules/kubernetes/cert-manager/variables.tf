variable "notification_email" {
  description = "Email address to send certificate expiration notifications"
  type        = string
  default     = "DG-Team-DevOps@xenit.se"
}

variable "server" {
  description = "ACME server to add to the created ClusterIssuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}
