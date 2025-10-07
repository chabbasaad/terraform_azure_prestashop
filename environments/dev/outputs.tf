output "prestashop_url" {
  description = "URL to access PrestaShop"
  value       = "https://${module.prestashop.fqdn}"
}

output "container_app_fqdn" {
  description = "Container App FQDN"
  value       = module.prestashop.fqdn
}

output "container_app_url" {
  description = "Container App URL with HTTPS"
  value       = "https://${module.prestashop.fqdn}"
}

output "database_host" {
  description = "Database host"
  value       = module.database.db_host
  sensitive   = true
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}
