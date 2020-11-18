variable "dns_provider" {
  description = "DNS provider to use."
  type        = string
}

variable "sources" {
  description = "k8s resource types to observe"
  type        = list(string)
  default     = ["ingress"]
}

variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "azure_tenant_id" {
  type    = string
  default = ""
}

variable "azure_resource_group" {
  type    = string
  default = ""
}

variable "azure_client_id" {
  type    = string
  default = ""
}
