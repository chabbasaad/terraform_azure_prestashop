output "action_group_id" {
  description = "ID du groupe d'actions pour les alertes"
  value       = azurerm_monitor_action_group.main.id
}

output "dashboard_id" {
  description = "ID du dashboard de monitoring"
  value       = azurerm_portal_dashboard.main.id
}

output "alert_rules" {
  description = "Liste des règles d'alerte créées"
  value = {
    database_cpu         = var.enable_database_alerts ? azurerm_monitor_metric_alert.database_cpu[0].id : null
    database_memory      = var.enable_database_alerts ? azurerm_monitor_metric_alert.database_memory[0].id : null
    database_connections = var.enable_database_alerts ? azurerm_monitor_metric_alert.database_connections[0].id : null
    app_response_time    = var.enable_app_alerts ? azurerm_monitor_metric_alert.app_response_time[0].id : null
    app_error_rate       = var.enable_app_alerts ? azurerm_monitor_metric_alert.app_error_rate[0].id : null
  }
}