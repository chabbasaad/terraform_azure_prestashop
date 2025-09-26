# Outputs pour l'environnement de staging

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = azurerm_resource_group.main.name
}

output "prestashop_url" {
  description = "URL de l'application PrestaShop"
  value       = module.prestashop.app_url
}

output "database_connection_info" {
  description = "Informations de connexion à la base de données"
  value = {
    host     = module.database.db_host
    database = module.database.database_name
    port     = module.database.db_port
  }
}

output "admin_access" {
  description = "Informations d'accès administrateur"
  value = {
    prestashop_url   = module.prestashop.app_url
    admin_email      = var.admin_email
    admin_url        = "${module.prestashop.app_url}/admin"
  }
}

output "monitoring_info" {
  description = "Informations de monitoring"
  value = {
    dashboard_id     = module.monitoring.dashboard_id
    action_group_id  = module.monitoring.action_group_id
    alert_rules      = module.monitoring.alert_rules
  }
}

output "networking_info" {
  description = "Informations de réseau"
  value = {
    vnet_id                    = module.networking.vnet_id
    container_apps_subnet_id   = module.networking.container_apps_subnet_id
    database_subnet_id         = module.networking.database_subnet_id
  }
}

output "secrets_info" {
  description = "Informations sur le Key Vault"
  value = {
    key_vault_name = module.secrets.key_vault_name
    key_vault_id   = module.secrets.key_vault_id
  }
}

# Configuration pour les tests de performance
output "load_testing_config" {
  description = "Configuration pour les tests de charge"
  value = {
    target_url              = module.prestashop.app_url
    expected_max_replicas   = 8
    concurrent_users_test   = 50
    duration_minutes        = 10
  }
}

# Output sensible pour les scripts d'automatisation
output "database_password" {
  description = "Mot de passe de la base de données"
  value       = var.db_password
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Chaîne de connexion Application Insights"
  value       = module.prestashop.application_insights_connection_string
  sensitive   = true
}