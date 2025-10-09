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
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-taylor-shift"
    storage_account_name = "sttfstatetaylor09270dd"
    container_name       = "tfstate"
    key                  = "staging/terraform.tfstate"
    use_azuread_auth     = false
  }
}

provider "azurerm" {
  features {
    # key_vault {
    #   purge_soft_delete_on_destroy    = true
    #   recover_soft_deleted_key_vaults = true
    # }
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

# Application Insights for monitoring
resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "ts-log-${local.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_application_insights" "prestashop" {
  name                = "ts-appinsights-${local.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.monitoring.id
  application_type    = "web"
  tags                = local.common_tags
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
  source = "../../modules/prestashop"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  db_host             = module.database.db_host
  db_name             = "prestashop"
  db_user             = var.db_admin_user
  db_password         = var.db_password
  admin_email         = var.admin_email
  admin_password      = var.prestashop_admin_password
  min_replicas         = local.config.min_replicas
  max_replicas         = local.config.max_replicas

  # Force explicit dependency to ensure database is ready
  depends_on = [module.database, azurerm_application_insights.prestashop]
}
