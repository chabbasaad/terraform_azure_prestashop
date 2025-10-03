# Database Module Outputs

output "db_host" {
  description = "Database hostname"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "db_name" {
  description = "Database name"
  value       = azurerm_mysql_flexible_database.prestashop.name
}

output "db_user" {
  description = "Database username"
  value       = azurerm_mysql_flexible_server.main.administrator_login
}

output "server_id" {
  description = "Database server ID"
  value       = azurerm_mysql_flexible_server.main.id
}

output "server_name" {
  description = "Database server name"
  value       = azurerm_mysql_flexible_server.main.name
}
output "database_name" {
  value = azurerm_mysql_flexible_server.main.name
}

output "db_port" {
  value = 3306 //TODO
}