output "prestashop_url" {
  description = "URL to access PrestaShop"
  value       = "https://${module.prestashop.fqdn}"
}

output "container_app_fqdn" {
  description = "Container App FQDN"
  value       = module.prestashop.fqdn
}

output "database_host" {
  description = "Database host"
  value       = module.database.db_host
  sensitive   = true
}

output "redis_info" {
  description = "Redis Cache information"
  value = {
    hostname = azurerm_redis_cache.prestashop.hostname
    ssl_port = azurerm_redis_cache.prestashop.ssl_port
    sku_name = azurerm_redis_cache.prestashop.sku_name
  }
  sensitive = true
}

output "application_insights" {
  description = "Application Insights monitoring information"
  value = {
    name                = azurerm_application_insights.prestashop.name
    instrumentation_key = azurerm_application_insights.prestashop.instrumentation_key
    app_id              = azurerm_application_insights.prestashop.app_id
  }
  sensitive = true
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "admin_access" {
  description = "Informations d'accès administrateur"
  value = {
    prestashop_url = "https://${module.prestashop.fqdn}"
    admin_email    = var.admin_email
    admin_url      = "https://${module.prestashop.fqdn}/adminportal"
  }
  sensitive = true
}

output "production_summary" {
  description = "Résumé de la configuration production"
  value = {
    environment        = local.environment
    location           = var.location
    mysql_sku          = local.config.db_sku
    mysql_storage_gb   = local.config.db_storage_gb
    redis_sku          = "basic c1"
    min_replicas       = local.config.min_replicas
    max_replicas       = local.config.max_replicas
    cpu_per_replica    = local.config.cpu_limit
    memory_per_replica = local.config.memory_limit
  }
}
