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
  description = "Azure specific configuration"
  type = object({
    subscription_id     = string,
    hosted_zone_name    = list(string),
    resource_group_name = string,
    client_id           = string,
    resource_id         = string,
  })
  default = {
    subscription_id     = "",
    hosted_zone_name    = [""],
    resource_group_name = "",
    client_id           = "",
    resource_id         = "",
  }
}

variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    region         = string,
    hosted_zone_id = map(string, string)
    role_arn       = string,
  })
  default = {
    region         = "",
    hosted_zone_id = {},
    role_arn       = "",
  }
}
