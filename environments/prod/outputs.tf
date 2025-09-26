# Outputs pour l'environnement de production

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = azurerm_resource_group.main.name
}

output "prestashop_url" {
  description = "URL de l'application PrestaShop en production"
  value       = module.prestashop.app_url
}

output "production_domain_url" {
  description = "URL du domaine de production"
  value       = "https://${var.production_domain}"
}

output "database_connection_info" {
  description = "Informations de connexion à la base de données"
  value = {
    host     = module.database.db_host
    database = module.database.database_name
    port     = module.database.db_port
    ssl      = "required"
  }
}

output "admin_access" {
  description = "Informations d'accès administrateur"
  value = {
    prestashop_url   = module.prestashop.app_url
    admin_email      = var.admin_email
    admin_url        = "${module.prestashop.app_url}/admin"
    domain_url       = "https://${var.production_domain}"
  }
}

output "monitoring_info" {
  description = "Informations de monitoring critique"
  value = {
    dashboard_id     = module.monitoring.dashboard_id
    action_group_id  = module.monitoring.action_group_id
    alert_rules      = module.monitoring.alert_rules
    backup_vault_id  = azurerm_backup_vault.main.id
  }
}

output "networking_info" {
  description = "Informations de réseau sécurisé"
  value = {
    vnet_id                    = module.networking.vnet_id
    container_apps_subnet_id   = module.networking.container_apps_subnet_id
    database_subnet_id         = module.networking.database_subnet_id
    private_dns_zone_id        = module.networking.private_dns_zone_id
  }
}

output "secrets_info" {
  description = "Informations sur le Key Vault sécurisé"
  value = {
    key_vault_name = module.secrets.key_vault_name
    key_vault_id   = module.secrets.key_vault_id
  }
}

# Configuration pour les tests de charge haute performance
output "load_testing_config" {
  description = "Configuration pour les tests de charge de production"
  value = {
    target_url              = "https://${var.production_domain}"
    expected_max_replicas   = 50
    concurrent_users_test   = 10000     # Test avec 10k utilisateurs simultanés
    duration_minutes        = 60        # Test de 1 heure
    ramp_up_minutes         = 15        # Montée en charge sur 15 minutes
    target_rps              = 1000      # 1000 requêtes/seconde cible
  }
}

# Informations de sécurité
output "security_info" {
  description = "Informations de sécurité de production"
  value = {
    resource_lock_id     = azurerm_management_lock.resource_group.id
    backup_vault_id      = azurerm_backup_vault.main.id
    ssl_enforcement      = "enabled"
    private_networking   = "enabled"
    monitoring_level     = "comprehensive"
  }
}

# Performance et scalabilité
output "performance_metrics" {
  description = "Métriques de performance attendues"
  value = {
    min_replicas              = 5
    max_replicas              = 50
    autoscaling_threshold     = 5
    expected_response_time_ms = 200
    expected_availability     = "99.9%"
    expected_concurrent_users = 10000
  }
}

# Informations de compliance et backup
output "compliance_info" {
  description = "Informations de conformité et sauvegarde"
  value = {
    backup_retention_days     = 35
    geo_redundant_backup     = "enabled"
    encryption_at_rest       = "enabled"
    encryption_in_transit    = "enabled"
    audit_logging            = "enabled"
    disaster_recovery        = "geo-redundant"
  }
}

# Output sensible pour les scripts d'automatisation (accès restreint)
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

# URL pour le dashboard de monitoring Azure
output "azure_portal_links" {
  description = "Liens vers les ressources dans le portail Azure"
  value = {
    resource_group    = "https://portal.azure.com/#@/resource${azurerm_resource_group.main.id}"
    monitoring        = "https://portal.azure.com/#@/resource${module.monitoring.dashboard_id}"
    database          = "https://portal.azure.com/#@/resource${module.database.server_id}"
    application       = "https://portal.azure.com/#@/resource${module.prestashop.container_app_id}"
  }
}