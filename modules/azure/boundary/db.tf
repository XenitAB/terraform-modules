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

  sku_name   = "B_Gen4_1"
  version    = "9.6"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "controller" {
  name                = "controller"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_postgresql_server.controller.name
  #charset             = "utf8"
  #collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "controller" {
  name                = "PostgreSQL Controller Access"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.controller.name
  start_ip_address    = "210.170.94.100"
  end_ip_address      = "210.170.94.120"
}
