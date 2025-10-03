output "key_vault_id" {
  description = "ID du Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.main.name
}
output "db_password_secret_id" {
  value       = azurerm_key_vault_secret.db_password.id
  description = "ID du secret db-password dans Key Vault"
}

output "prestashop_key_secret_id" {
  value       = azurerm_key_vault_secret.prestashop_key.id
  description = "ID du secret prestashop-key dans Key Vault"
}

output "dockerhub_username_secret_id" {
  value       = azurerm_key_vault_secret.dockerhub_username.id
  description = "ID du secret dockerhub-username dans Key Vault"
}

output "dockerhub_password_secret_id" {
  value       = azurerm_key_vault_secret.dockerhub_password.id
  description = "ID du secret dockerhub-password dans Key Vault"
}
