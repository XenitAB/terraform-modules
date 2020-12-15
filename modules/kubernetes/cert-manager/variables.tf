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

variable "azure_config" {
  description = "AWS specific configuration"
  type = object({
    subscription_id = string,
    hosted_zone       = string,
    resource_group  = string,
    client_id       = string,
    resource_id     = string
  })
  default = {
    subscription_id = "",
    hosted_zone       = "",
    resource_group  = "",
    client_id       = "",
    resource_id     = ""
  }
}
