/**
  * # GitHub Actions Self-hosted Runner
  *
  * This is the setup for GitHub Actions Self-hosted Runner Virtual Machine Scale Set (VMSS).
  *
  * ## GitHub Runner Configuration
  *
  * Setup a GitHub App according to the documentation for [XenitAB/github-runner](https://github.com/XenitAB/github-runner).
  *
  * Setup an image using Packer according [github-runner](https://github.com/XenitAB/packer-templates/tree/main/templates/azure/github-runner) in [XenitAB/packer-templates](https://github.com/XenitAB/packer-templates).
  */

terraform {
  required_version = ">= 1.1.7"

  required_providers {
    azurerm = {
      version = "3.1.0"
      source  = "hashicorp/azurerm"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

data "azurerm_subscription" "this" {}

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

# START - Validation of secrets that will be used by GitHub Runner
# tflint-ignore: terraform_unused_declarations
data "azurerm_key_vault_secret" "github_secrets" {
  for_each = { for secret_name in [var.github_organization_kvsecret, var.github_app_id_kvsecret, var.github_installation_id_kvsecret, var.github_private_key_kvsecret] :
    secret_name => secret_name
  }

  name         = each.key
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_image" "this" {
  name                = var.github_runner_image_name
  resource_group_name = local.github_runner_image_resource_group_name
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
  custom_data                     = base64encode(local.custom_data)

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

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags,
      instances
    ]
  }
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = data.azurerm_key_vault.this.id

  tenant_id = data.azurerm_subscription.this.tenant_id
  object_id = azurerm_linux_virtual_machine_scale_set.this.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
}
