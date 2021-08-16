/**
  * # Azure Pipelines Agent
  *
  * This is the setup for Azure Pipelines Agent Virtual Machine Scale Set (VMSS).
  *
  * ## Azure DevOps Configuration
  *
  * Follow this guide to setup the agent pool (manually): https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops#create-the-scale-set-agent-pool
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    azurerm = {
      version = "2.72.0"
      source  = "hashicorp/azurerm"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

data "azurerm_subnet" "this" {
  name                 = var.vmss_subnet_config.name
  virtual_network_name = var.vmss_subnet_config.virtual_network_name
  resource_group_name  = var.vmss_subnet_config.resource_group_name
}

data "azurerm_key_vault" "this" {
  name                = local.keyvault_name
  resource_group_name = local.keyvault_resource_group_name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "this" {
  name         = "ssh-priv-${var.environment}-${var.location_short}-${var.name}"
  value        = jsonencode(tls_private_key.this)
  key_vault_id = data.azurerm_key_vault.this.id
  content_type = "application/json"
}

data "azurerm_image" "this" {
  name                = var.azure_pipelines_agent_image_name
  resource_group_name = local.azure_pipelines_agent_image_resource_group_name
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                            = "vmss-${var.environment}-${var.location_short}-${var.name}"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  sku                             = var.vmss_sku
  instances                       = var.vmss_instances
  admin_username                  = var.vmss_admin_username
  disable_password_authentication = true
  overprovision                   = false
  zones                           = var.vmss_zones

  admin_ssh_key {
    username   = var.vmss_admin_username
    public_key = tls_private_key.this.public_key_openssh
  }

  source_image_id = data.azurerm_image.this.id

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.vmss_disk_size_gb
    diff_disk_settings {
      option = "Local"
    }
  }

  network_interface {
    name    = "nic-01"
    primary = true

    ip_configuration {
      name      = "ipconfig-01"
      primary   = true
      subnet_id = data.azurerm_subnet.this.id
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
      instances
    ]
  }
}
