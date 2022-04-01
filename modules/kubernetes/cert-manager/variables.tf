variable "notification_email" {
  description = "Email address to send certificate expiration notifications"
  type        = string
}

variable "acme_server" {
  description = "ACME server to add to the created ClusterIssuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cloud_provider" {
  description = "Cloud provider to use."
  type        = string
}

variable "ingress_public_private_enabled" {
  description = "Which ingressclass should cert-manager use?"
  type        = bool
  default     = false
}
