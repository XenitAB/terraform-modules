variable "dns_provider" {
  description = "DNS provider to use."
  type        = string
}

variable "sources" {
  description = "k8s resource types to observe"
  type        = list(string)
  default     = ["ingress"]
}

variable "azure_config" {
  description = "AWS specific configuration"
  type = object({
    subscription_id = string,
    tenant_id       = string,
    resource_group  = string,
    client_id       = string,
    resource_id     = string
  })
  default = {
    subscription_id = "",
    tenant_id       = "",
    resource_group  = "",
    client_id       = "",
    resource_id     = ""
  }
}

variable "aws_config" {
  description = "AWS specific configuration"
  type = object({
    role_arn = string,
    region   = string
  })
  default = {
    role_arn = "",
    region   = ""
  }
}

variable "input_depends_on" {
  description = "Input dependency for module"
  type        = any
  default     = {}
}