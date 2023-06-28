locals {
  backend_address_pool_name      = "${azurerm_kubernetes_cluster.this.name}-beap"
  frontend_port_name             = "${azurerm_kubernetes_cluster.this.name}-feport"
  frontend_ip_configuration_name = "${azurerm_kubernetes_cluster.this.name}-feip"
  http_setting_name              = "${azurerm_kubernetes_cluster.this.name}-be-htst"
  listener_name                  = "${azurerm_kubernetes_cluster.this.name}-httplstn"
  request_routing_rule_name      = "${azurerm_kubernetes_cluster.this.name}-rqrt"
  redirect_configuration_name    = "${azurerm_kubernetes_cluster.this.name}-rdrcfg"
}

resource "azurerm_public_ip" "agw" {
  name                = "agw-pip-${azurerm_kubernetes_cluster.this.name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "this" {
  name                = "agw-${azurerm_kubernetes_cluster.this.name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${azurerm_kubernetes_cluster.this.name}-ip-config"
    subnet_id = data.azurerm_subnet.this.id

  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
