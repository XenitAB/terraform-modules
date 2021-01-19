resource "azurerm_public_ip" "controller" {
  name                = "pubip-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  sku = "standard"
  allocation_method   = "Static"
  domain_name_label   = data.azurerm_resource_group.this.name
}

resource "azurerm_lb" "controller" {
  name                = "lb-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name             = data.azurerm_resource_group.this.name
  location                        = data.azurerm_resource_group.this.location
  sku = "standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.controller.id
  }
}

resource "azurerm_lb_backend_address_pool" "controller" {
  name                = "lb-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name = data.azurerm_resource_group.this.name
  loadbalancer_id     = azurerm_lb.controller.id
}

resource "azurerm_lb_probe" "controller" {
  name                = "lb-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name = data.azurerm_resource_group.this.name
  loadbalancer_id     = azurerm_lb.controller.id
  port                = "22"
}

resource "azurerm_lb_rule" "controller" {
  name                           = "http"
  resource_group_name            = data.azurerm_resource_group.this.name
  loadbalancer_id                = azurerm_lb.controller.id
  protocol                       = "tcp"
  frontend_port                  = "9200"
  backend_port                   = "9200"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.controller.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.controller.id
}

resource "azurerm_lb_rule" "controller_ssh" {
  name                           = "ssh"
  resource_group_name            = data.azurerm_resource_group.this.name
  loadbalancer_id                = azurerm_lb.controller.id
  protocol                       = "tcp"
  frontend_port                  = "22"
  backend_port                   = "22"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.controller.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.controller.id
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
  custom_data                     = base64encode(local.custom_data)

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
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.controller.id]
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_key" "controller_root" {
  name         = "boundary-root"
  key_vault_id = data.azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_key" "controller_worker_auth" {
  name         = "boundary-worker-auth"
  key_vault_id = data.azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "controller" {
  key_vault_id = data.azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = azurerm_linux_virtual_machine_scale_set.controller.identity[0].principal_id

  key_permissions = [
    "get",
    "wrapKey",
  ]
}
