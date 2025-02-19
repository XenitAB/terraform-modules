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
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
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

  source_image_id = var.source_image_id

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
      subnet_id = var.vmss_subnet_id
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
      instances
    ]
  }
}
