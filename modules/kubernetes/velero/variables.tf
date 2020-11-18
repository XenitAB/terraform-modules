variable "cloud_provider" {
  description = "Cloud provider to use."
  type        = string
  default     = "azure"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID for DNS zone"
  type        = string
  default     = ""
}

variable "azure_resource_group" {
  description = "Azure resource group for DNS zone"
  type        = string
  default     = ""
}

variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
  default     = ""
}

variable "azure_storage_account_container" {
  description = "Azure storage account container name"
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
