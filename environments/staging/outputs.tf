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

output "database_connection_info" {
  description = "Informations de connexion à la base de données"
  value = {
    host     = module.database.db_host
    database = module.database.database_name
    port     = module.database.db_port
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

output "load_testing_config" {
  description = "Configuration pour les tests de charge"
  value = {
    target_url            = "https://${module.prestashop.fqdn}"
    expected_max_replicas = 8
    concurrent_users_test = 50
    duration_minutes      = 10
  }
}

output "application_insights" {
  description = "Application Insights monitoring information"
  value = {
    name                = azurerm_application_insights.prestashop.name
    instrumentation_key = azurerm_application_insights.prestashop.instrumentation_key
    app_id              = azurerm_application_insights.prestashop.app_id
    connection_string   = azurerm_application_insights.prestashop.connection_string
  }
  sensitive = true
}

output "log_analytics_workspace" {
  description = "Log Analytics Workspace information"
  value = {
    name         = azurerm_log_analytics_workspace.monitoring.name
    workspace_id = azurerm_log_analytics_workspace.monitoring.workspace_id
  }
}

