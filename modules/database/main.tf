# Simplified Database Module
# Based on working version with minimal configuration



resource "azurerm_mysql_flexible_server" "main" {
  name                   = "ts-db-${var.environment}-saadhamzaconstant"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  
  sku_name = var.db_sku_name
  version  = "8.0.21"

  # Storage configuration from variables
  storage {
    size_gb           = var.storage_size_gb
    auto_grow_enabled = false
  }

  # Backup configuration from variables
  backup_retention_days = var.backup_retention_days
  geo_redundant_backup_enabled = false

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Database for PrestaShop
resource "azurerm_mysql_flexible_database" "prestashop" {
  name                = "prestashop"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Simple firewall rule for dev
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_all" {
  name                = "DevAccess"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

# Configuration to disable SSL requirement for dev
resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  value               = "OFF"
}
