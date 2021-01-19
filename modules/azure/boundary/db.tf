resource "random_password" "controller" {
  length = 32
  special = true
  override_special = "_%@"
}

resource "azurerm_postgresql_server" "controller" {
  name                = "psql-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  administrator_login          = "psqladmin"
  administrator_login_password = random_password.controller.result

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "controller" {
  name                = "controller"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_postgresql_server.controller.name
  charset             = "utf8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "controller" {
  name                = "psql-${var.environment}-${var.location_short}-${var.name}-controller"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_postgresql_server.controller.name
  subnet_id           = data.azurerm_subnet.this.id
}
