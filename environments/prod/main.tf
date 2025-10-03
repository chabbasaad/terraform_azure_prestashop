# Configuration Terraform pour l'environnement de production Taylor Shift
# Environnement: prod - Configuration haute performance et haute disponibilité

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

  # Backend pour stocker l'état Terraform (OBLIGATOIRE pour production)
 /** backend "azurerm" {
    resource_group_name  = "ts-tfstate-rg"
    storage_account_name = "tstfstateprod"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }*/
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false   # Protection en production
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true  # Protection en production
    }
  }
}

provider "random" {}



# Groupe de ressources principal
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = var.location

  tags = local.common_tags

  # Protection contre la suppression accidentelle
  lifecycle {
    prevent_destroy = true
  }
  subscription_id            = var.subscription_id

}

# Module de mise en réseau (obligatoire pour production)
module "networking" {
  source = "../../modules/networking"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  enable_vnet         = local.config.enable_vnet
  enable_private_dns  = local.config.enable_private_dns
  
  # Configuration réseau sécurisée pour production
  vnet_address_space             = "10.1.0.0/16"
  container_apps_subnet_address  = "10.1.1.0/24"
  database_subnet_address        = "10.1.2.0/24"
}

# Module de gestion des secrets (sécurisé)
module "secrets" {
  source = "../../modules/secrets"

  location                              = var.location
  resource_group_name                   = azurerm_resource_group.main.name
  environment                          = local.environment
  db_password                          = var.db_password
  dockerhub_username                   = var.dockerhub_username
  dockerhub_password                   = var.dockerhub_password
  container_app_identity_principal_id  = module.prestashop.user_assigned_identity_principal_id
}

# Module base de données (haute disponibilité)
module "database" {
  source = "../../modules/database"

  location                  = var.location
  resource_group_name       = azurerm_resource_group.main.name
  environment              = local.environment
  admin_user               = var.db_admin_user
  admin_password           = var.db_password
  db_sku_name              = local.config.db_sku
  storage_size_gb          = local.config.db_storage_gb
  backup_retention_days    = local.config.db_backup_retention
  enable_monitoring        = local.config.enable_monitoring
  action_group_id          = module.monitoring.action_group_id
  
  # Configuration haute performance pour production
  innodb_buffer_pool_size  = "2147483648"    # 2GB buffer pool
  max_connections          = "1000"          # Plus de connexions
}

# Module PrestaShop (haute performance)
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
  concurrent_requests_threshold = local.config.concurrent_requests_threshold
  admin_email                  = var.admin_email
  admin_password               = var.prestashop_admin_password
  domain_name                  = var.production_domain
}

# Module monitoring complet (critique en production)
module "monitoring" {
  source = "../../modules/monitoring"

  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  environment             = local.environment
  admin_email             = var.admin_email
  webhook_url             = var.webhook_url
  database_id             = module.database.server_id
  application_insights_id = module.prestashop.application_insights_connection_string != "" ? split(";", module.prestashop.application_insights_connection_string)[0] : ""
  container_app_id        = module.prestashop.container_app_id
  subscription_id         = var.subscription_id
}

# Backup automatisé additionnel pour production
resource "azurerm_backup_vault" "main" {
  name                = "bv-${local.project}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "GeoRedundant"

  tags = local.common_tags
}

# Resource Lock pour éviter les suppressions accidentelles
resource "azurerm_management_lock" "resource_group" {
  name       = "rg-lock-${local.environment}"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of Taylor Shift production resources"
}