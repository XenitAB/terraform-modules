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
  description = "Azure subscription ID for DNS zone"
  type        = string
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure tenant ID for DNS zone"
  type        = string
  default     = ""
}

variable "azure_resource_group" {
  description = "Azure resource group for DNS zone"
  type        = string
  default     = ""
}

variable "azure_client_id" {
  description = "Client ID for MSI authentication"
  type        = string
  default     = ""
}

variable "azure_resource_id" {
  description = "Principal ID fo MSI authentication"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string
  default     = ""
}

variable "aws_role_arn" {
  description = "AWS role ARN to attach to service account"
  type        = string
  default     = ""
}
