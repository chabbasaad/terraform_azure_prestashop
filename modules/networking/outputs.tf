output "vnet_id" {
  description = "ID du Virtual Network"
  value       = var.enable_vnet ? azurerm_virtual_network.main[0].id : null
}

output "vnet_name" {
  description = "Nom du Virtual Network"
  value       = var.enable_vnet ? azurerm_virtual_network.main[0].name : null
}

output "container_apps_subnet_id" {
  description = "ID du subnet Container Apps"
  value       = var.enable_vnet ? azurerm_subnet.container_apps[0].id : null
}

output "database_subnet_id" {
  description = "ID du subnet de la base de données"
  value       = var.enable_vnet ? azurerm_subnet.database[0].id : null
}

output "private_dns_zone_id" {
  description = "ID de la zone DNS privée"
  value       = var.enable_vnet && var.enable_private_dns ? azurerm_private_dns_zone.database[0].id : null
}