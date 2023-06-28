locals {
  backend_address_pool_name      = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-beap"
  frontend_port_name             = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-feport"
  frontend_ip_configuration_name = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-feip"
  http_setting_name              = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-be-htst"
  listener_name                  = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-httplstn"
  request_routing_rule_name      = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-rqrt"
  redirect_configuration_name    = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-rdrcfg"
}

data "azurerm_subnet" "agw" {
  name                 = "sn-${var.environment}-${var.location_short}-${var.core_name}-agw"
  virtual_network_name = "vnet-${var.environment}-${var.location_short}-${var.core_name}"
  resource_group_name  = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

resource "azurerm_public_ip" "agw" {
  for_each = {
    for s in ["agw"] :
    s => s
    if var.appgw_enabled
  }

  name                = "agw-pip-aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "this" {
  for_each = {
    for s in ["agw"] :
    s => s
    if var.appgw_enabled
  }
  name                = "agw-aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "aks-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-ip-config"
    subnet_id = data.azurerm_subnet.agw.id

  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw[each.key].id
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
    priority                   = 1
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_version = "3.2"
  }
}
