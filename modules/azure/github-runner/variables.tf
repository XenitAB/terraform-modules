variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = ""
}

variable "keyvault_name" {
  description = "The keyvault name"
  type        = string
  default     = ""
}

variable "keyvault_resource_group_name" {
  description = "The keyvault resource group name"
  type        = string
  default     = ""
}

variable "source_image_id" {
  description = "The Azure Pipelines agent image id"
  type        = string
}

variable "vmss_admin_username" {
  description = "The admin username"
  type        = string
  default     = "ghradmin"
}

variable "vmss_instances" {
  description = "The number of instances"
  type        = number
  default     = 1
}

variable "vmss_sku" {
  description = "The sku for VMSS instances"
  type        = string
  default     = "Standard_F4s_v2"
}

variable "vmss_zones" {
  description = "The zones to place the VMSS instances"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "vmss_disk_size_gb" {
  description = "The disk size (in GB) for the VMSS instances"
  type        = number
  default     = 128
}

variable "vmss_diff_disk_placement" {
  description = "Specifies where to store the Ephemeral Disk. Possible values are CacheDisk and ResourceDisk. Defaults to CacheDisk. Changing this forces a new resource to be created."
  type        = string
  default     = "CacheDisk"

  validation {
    condition     = var.vmss_diff_disk_placement == "CacheDisk" || var.vmss_diff_disk_placement == "ResourceDisk"
    error_message = "Diff disk placement must be either 'CacheDisk' or 'ResourceDisk'."
  }
}

variable "vmss_subnet_config" {
  description = "The subnet configuration for the VMSS instances"
  type = object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
  })
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "github_organization_kvsecret" {
  description = "The Azure KeyVault Secret containing the GitHub Organization name"
  type        = string
  default     = "github-organization" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

variable "github_app_id_kvsecret" {
  description = "The Azure KeyVault Secret containing the GitHub App ID"
  type        = string
  default     = "github-app-id" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

variable "github_installation_id_kvsecret" {
  description = "The Azure KeyVault Secret containing the GitHub App Installation ID"
  type        = string
  default     = "github-installation-id" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

variable "github_private_key_kvsecret" {
  description = "The AzureKey Vault Secret containing the GitHub App Private Key"
  type        = string
  default     = "github-private-key" #tfsec:ignore:general-secrets-no-plaintext-exposure
}
