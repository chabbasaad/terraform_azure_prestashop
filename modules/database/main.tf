# Simplified Database Module
# Based on working version with minimal configuration

resource "random_string" "server_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_mysql_flexible_server" "main" {
  name                   = "ts-db-${var.environment}-${random_string.server_suffix.result}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  
  sku_name = "B_Standard_B1ms"
  version  = "8.0.21"

  # Storage configuration
  storage {
    size_gb           = 32
    auto_grow_enabled = true
  }

  # Backup configuration
  backup_retention_days = 7
  geo_redundant_backup_enabled = false

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
    Purpose     = "prestashop-database"
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

# Firewall rule to allow all IPs (like working version)
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_all" {
  name                = "AllowAll"
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
