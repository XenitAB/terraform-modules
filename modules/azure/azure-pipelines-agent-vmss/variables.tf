variable "location_short" {
  description = "The location (short name) for the region"
  type        = string
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
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

variable "azure_pipelines_agent_image_name" {
  description = "The Azure Pipelines agent image name"
  type        = string
}

variable "azure_pipelines_agent_image_resource_group_name" {
  description = "The Azure Pipelines agent image resource group name"
  type        = string
  default     = ""
}

variable "vmss_admin_username" {
  description = "The admin username"
  type        = string
  default     = "azpagent"
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
}
