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
