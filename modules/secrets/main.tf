# Azure Key Vault pour la gestion sécurisée des secrets
# Module: secrets

data "azurerm_client_config" "current" {}

resource "random_string" "keyvault_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                        = "ts-kv-${var.environment}-${random_string.keyvault_suffix.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.environment == "prod" ? "premium" : "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover"
    ]
  }

  # Politique d'accès pour les Container Apps
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.container_app_identity_principal_id

    secret_permissions = [
      "Get"
    ]
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Secret pour le mot de passe de la base de données
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.main.id
}

# Secret pour les credentials DockerHub
resource "azurerm_key_vault_secret" "dockerhub_username" {
  name         = "dockerhub-username"
  value        = var.dockerhub_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "dockerhub_password" {
  name         = "dockerhub-password"
  value        = var.dockerhub_password
  key_vault_id = azurerm_key_vault.main.id
}

# Secret pour la clé PrestaShop
resource "azurerm_key_vault_secret" "prestashop_key" {
  name         = "prestashop-key"
  value        = random_password.prestashop_key.result
  key_vault_id = azurerm_key_vault.main.id
}

resource "random_password" "prestashop_key" {
  length  = 32
  special = true
}