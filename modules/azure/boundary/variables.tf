variable "location_short" {
  description = "The location (short name) for the region"
  type        = string
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
  default = "boundary"
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

variable "boundary_image_name" {
  description = "Image name for Boundary"
  type = string
}

variable "vmss_admin_username" {
  description = "The admin username"
  type        = string
  default     = "boundaryadmin"
}

variable "controller_config" {
  description = "Configuration for controller VMSS"
  type = object({
    vmss_instances = number
    vmss_sku = string
    vmss_zones = list(string)
    vmss_disk_size_gb = number
  })
  default = {
    vmss_instances = 1,
    vmss_sku = "Standard_D2s_v3"
    vmss_zones = ["1", "2", "3"]
    vmss_disk_size_gb = 50
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
