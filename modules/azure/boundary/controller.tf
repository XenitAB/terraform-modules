resource "azurerm_public_ip" "controller" {
  name                = "pubip-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  allocation_method   = "Static"
  domain_name_label   = data.azurerm_resource_group.this.name
}

resource "azurerm_lb" "controller" {
  name                = "lb-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.controller.id
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "controller" {
  name                            = "vmss-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  sku                             = var.controller_config.vmss_sku
  instances                       = var.controller_config.vmss_instances
  admin_username                  = var.vmss_admin_username
  disable_password_authentication = true
  overprovision                   = false
  zones                           = var.controller_config.vmss_zones
  #custom_data                     = base64encode(local.custom_data)

  admin_ssh_key {
    username   = var.vmss_admin_username
    public_key = tls_private_key.this.public_key_openssh
  }

  source_image_id = data.azurerm_image.this.id

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.controller_config.vmss_disk_size_gb
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
