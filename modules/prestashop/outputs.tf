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

# User assigned identity and application insights outputs removed for faster dev deployment

output "app_url" {
  description = "Latest revision FQDN"
  value       = azurerm_container_app.prestashop.latest_revision_fqdn
}

output "container_app_environment_id" {
  description = "Container App Environment ID"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "Container App Environment Name"
  value       = azurerm_container_app_environment.main.name
}

output "fqdn" {
  description = "Container App FQDN for compatibility"
  value       = azurerm_container_app.prestashop.ingress[0].fqdn
}
