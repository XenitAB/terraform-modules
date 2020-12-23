/**
  * # Hub
  *
  * This module is used to create a separate network in one of the subscriptions (usually PROD) and connect it to all the networks.
  * 
  * ## Usage
  *
  * Use together with the `core` module to create a peered network where SPOF (single point of failure) resources can be created, lik Azure Pipelines Agent Virtual Machine Scale Set (VMSS).
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.1.1"
      source  = "hashicorp/azuread"
    }
  }
}

data "azurerm_resource_group" "this" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name = "rg-${each.value.name}"
}

resource "azurerm_virtual_network" "this" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name                = "vnet-${each.value.name}"
  resource_group_name = data.azurerm_resource_group.this[each.value.name].name
  location            = data.azurerm_resource_group.this[each.value.name].location
  address_space       = each.value.vnet_config.address_space
}

resource "azurerm_public_ip_prefix" "this" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name                = "ip-prefix-${each.key}"
  resource_group_name = data.azurerm_resource_group.this[each.key].name
  location            = data.azurerm_resource_group.this[each.key].location
  prefix_length       = var.nat_gateway_public_ip_prefix_length
}

resource "azurerm_nat_gateway" "this" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name                    = "natgw-${each.key}"
  resource_group_name     = data.azurerm_resource_group.this[each.key].name
  location                = data.azurerm_resource_group.this[each.key].location
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.this[each.key].id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}


resource "azurerm_subnet" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  name                 = each.value.subnet_full_name
  resource_group_name  = data.azurerm_resource_group.this[each.value.vnet_resource].name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_resource].name
  address_prefixes     = [each.value.subnet_cidr]
  service_endpoints    = each.value.subnet_service_endpoints
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[each.value.vnet_resource].id
}

resource "azurerm_network_security_group" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  name                = "nsg-${var.environment}-${each.value.vnet_region}-${var.name}-${each.value.subnet_short_name}"
  location            = data.azurerm_resource_group.this[each.value.vnet_resource].location
  resource_group_name = data.azurerm_resource_group.this[each.value.vnet_resource].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = {
    for peering_config in local.peerings :
    peering_config.name => peering_config
  }

  name                         = "peering-${each.value.name}"
  resource_group_name          = data.azurerm_resource_group.this[each.value.env_resource_name].name
  virtual_network_name         = azurerm_virtual_network.this[each.value.env_resource_name].name
  remote_virtual_network_id    = each.value.peering_config.remote_virtual_network_id
  allow_forwarded_traffic      = each.value.peering_config.allow_forwarded_traffic
  use_remote_gateways          = each.value.peering_config.use_remote_gateways
  allow_virtual_network_access = each.value.peering_config.allow_virtual_network_access
}

resource "azurerm_role_definition" "service_endpoint_join" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name  = "role-${each.value.name}-serviceEndpointJoin"
  scope = azurerm_virtual_network.this[each.key].id

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network.this[each.key].id
  ]
}

data "azuread_group" "service_endpoint_join" {
  name = "${var.azure_ad_group_prefix}${var.group_name_separator}sub${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}serviceEndpointJoin"
}

resource "azurerm_role_assignment" "service_endpoint_join" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  scope              = azurerm_virtual_network.this[each.key].id
  role_definition_id = azurerm_role_definition.service_endpoint_join[each.key].role_definition_resource_id
  principal_id       = data.azuread_group.service_endpoint_join.id
}
