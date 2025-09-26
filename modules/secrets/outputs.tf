output "key_vault_id" {
  description = "ID du Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.main.name
}

output "db_password_secret_id" {
  description = "ID du secret du mot de passe de la base de données"
  value       = azurerm_key_vault_secret.db_password.id
}

output "prestashop_key_secret_id" {
  description = "ID du secret de la clé PrestaShop"
  value       = azurerm_key_vault_secret.prestashop_key.id
}

output "dockerhub_username_secret_id" {
  description = "ID du secret du nom d'utilisateur DockerHub"
  value       = azurerm_key_vault_secret.dockerhub_username.id
}

output "dockerhub_password_secret_id" {
  description = "ID du secret du mot de passe DockerHub"
  value       = azurerm_key_vault_secret.dockerhub_password.id
}