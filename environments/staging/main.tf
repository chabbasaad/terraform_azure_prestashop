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

resource "azurerm_resource_group" "tfstate" {
  name     = "ts-tfstate-rg"
  location = "westeurope"
  tags     = local.common_tags
}

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "ts-log-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tstfstatestaging"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  //allow_blob_public_access = false
  tags                     = local.common_tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source = "../../modules/networking"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  enable_vnet         = local.config.enable_vnet
  enable_private_dns  = true
}

module "secrets" {
  source = "../../modules/secrets"
  location                              = var.location
  resource_group_name                   = azurerm_resource_group.main.name
  environment                           = local.environment
  db_password                           = var.db_password
  dockerhub_username                    = var.dockerhub_username
  dockerhub_password                    = var.dockerhub_password
  container_app_identity_principal_id   = module.prestashop.user_assigned_identity_principal_id
}

module "database" {
  source = "../../modules/database"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.main.name
  environment               = local.environment
  admin_user                = var.db_admin_user
  admin_password            = var.db_password
  db_sku_name               = local.config.db_sku
  storage_size_gb           = 128
  backup_retention_days     = local.config.db_backup_retention
  enable_monitoring         = local.config.enable_monitoring
  action_group_id           = module.monitoring.action_group_id
}

module "prestashop" {
  source = "../../modules/prestashop-simple"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.main.name
  environment                  = local.environment
  db_host                      = module.database.db_host
  db_name                      = "prestashop"
  db_user                      = var.db_admin_user
  db_password                  = var.db_password
  min_replicas                 = local.config.min_replicas
  max_replicas                 = local.config.max_replicas
  cpu_limit                    = local.config.cpu_limit
  memory_limit                 = local.config.memory_limit
  enable_autoscaling           = true
  concurrent_requests_threshold = 15
  admin_email                  = var.custom_domain
  admin_password               = var.prestashop_admin_password
  domain_name                  = var.custom_domain

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}

module "monitoring" {
  source = "../../modules/monitoring"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  environment              = local.environment
  admin_email              = var.admin_email
  webhook_url              = var.webhook_url
  database_id              = module.database.server_id
  application_insights_id = module.prestashop.application_insights_connection_string != "" ? split(";", module.prestashop.application_insights_connection_string)[0] : ""
  container_app_id         = module.prestashop.container_app_id
  subscription_id          = var.subscription_id
}