# Configuration Terraform pour l'environnement de staging Taylor Shift
# Environnement: staging - Réplique de production à plus petite échelle

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

  # Backend pour stocker l'état Terraform
  backend "azurerm" {
    resource_group_name  = "ts-tfstate-rg"
    storage_account_name = "tstfstatestaging"
    container_name       = "tfstate"
    key                  = "staging.terraform.tfstate"
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
}

provider "random" {}

# Configuration des variables locales pour l'environnement staging
locals {
  environment = "staging"
  project     = "taylor-shift"
  
  # Tags communs
  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "taylor-shift-team"
  }

  # Configuration spécifique au staging (réplique prod à plus petite échelle)
  config = {
    # Base de données
    db_sku              = "GP_Standard_D2ds_v4"    # SKU General Purpose
    db_storage_gb       = 128                      # Stockage intermédiaire
    db_backup_retention = 14                       # Rétention intermédiaire
    
    # Application
    min_replicas = 2                               # 2 répliques minimum
    max_replicas = 8                               # 8 répliques maximum
    cpu_limit    = 1.0                             # CPU standard
    memory_limit = "2Gi"                           # Mémoire standard
    
    # Monitoring
    enable_monitoring = true                       # Monitoring complet
    
    # Networking
    enable_vnet = true                             # VNet activé comme en prod
  }
}

# Groupe de ressources principal
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = var.location

  tags = local.common_tags
}

# Module de mise en réseau (activé pour staging)
module "networking" {
  source = "../../modules/networking"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  enable_vnet         = local.config.enable_vnet
  enable_private_dns  = true
}

# Module de gestion des secrets
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

# Module base de données
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
}

# Module PrestaShop
module "prestashop" {
  source = "../../modules/prestashop"

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
  concurrent_requests_threshold = 15    # Seuil plus bas pour tester l'autoscaling
  admin_email                  = var.admin_email
  admin_password               = var.prestashop_admin_password
  domain_name                  = var.custom_domain
}

# Module monitoring complet
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