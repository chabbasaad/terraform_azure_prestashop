# PrestaShop Module Outputs

output "prestashop_url" {
  description = "PrestaShop application URL"
  value       = "https://${azurerm_container_app.prestashop.ingress[0].fqdn}"
}

output "container_app_id" {
  description = "Container App ID"
  value       = azurerm_container_app.prestashop.id
}

output "container_app_fqdn" {
  description = "Container App FQDN"
  value       = azurerm_container_app.prestashop.ingress[0].fqdn
}
output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.prestashop.principal_id
}

output "application_insights_connection_string" {
  value = azurerm_application_insights.prestashop.connection_string
}

output "app_url" {
  value = azurerm_container_app.prestashop.latest_revision_fqdn
}
