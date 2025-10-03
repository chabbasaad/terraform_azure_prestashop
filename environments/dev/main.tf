terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id            = var.subscription_id
  skip_provider_registration = false
}

provider "random" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = var.location
  tags     = local.common_tags
}


resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "ts-log-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


module "database" {
  source = "../../modules/database"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  admin_user          = var.db_admin_user
  admin_password      = var.db_password

  storage_size_gb       = local.config.db_storage_gb
  enable_monitoring     = local.config.enable_monitoring
  db_sku_name           = local.config.db_sku
  backup_retention_days = local.config.db_backup_retention
}

module "prestashop" {
  source = "../../modules/prestashop-simple"

  location                    = var.location
  resource_group_name         = azurerm_resource_group.main.name
  environment                 = local.environment
  db_host                     = module.database.db_host
  db_name                     = "prestashop"
  db_user                     = var.db_admin_user
  db_password                 = var.db_password
  admin_email                 = var.admin_email
  admin_password              = var.prestashop_admin_password

  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring.id
}