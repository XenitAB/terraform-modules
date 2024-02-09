variable "notification_email" {
  description = "Email address to send certificate expiration notifications"
  type        = string
}

variable "acme_server" {
  description = "ACME server to add to the created ClusterIssuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    subscription_id     = string,
    hosted_zone_names   = list(string),
    resource_group_name = string,
    client_id           = string,
    resource_id         = string,
  })
  default = {
    subscription_id     = "",
    hosted_zone_names   = [],
    resource_group_name = "",
    client_id           = "",
    resource_id         = "",
  }
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}
