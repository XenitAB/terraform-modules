variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "dns_provider" {
  description = "DNS provider to use."
  type        = string
}

variable "sources" {
  description = "k8s resource types to observe"
  type        = list(string)
  default     = ["ingress", "service"]
}

variable "txt_owner_id" {
  description = "The txt-owner-id for external-dns"
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    subscription_id = string,
    tenant_id       = string,
    resource_group  = string,
    client_id       = string,
  })
  default = {
    subscription_id = "",
    tenant_id       = "",
    resource_group  = "",
    client_id       = "",
  }
}
