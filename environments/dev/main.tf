# Simplified Dev Environment for Taylor Shift
# Based on working version but with Container Apps for scaling

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
  subscription_id            = "98986790-05f9-4237-b612-4814a09270dd"
  skip_provider_registration = false
}

provider "random" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-taylor-shift-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
    ManagedBy   = "terraform"
  }
}

# Database Module
module "database" {
  source = "../../modules/database"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  admin_user          = var.db_admin_user
  admin_password      = var.db_password
}

# PrestaShop Module (with Container Apps for scaling)
module "prestashop" {
  source = "../../modules/prestashop-simple"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  db_host             = module.database.db_host
  db_name             = "prestashop"
  db_user             = var.db_admin_user
  db_password         = var.db_password
  admin_email         = var.admin_email
  admin_password      = var.prestashop_admin_password
}

# Outputs
output "database_connection_info" {
  description = "Database connection information"
  value = {
    host     = module.database.db_host
    database = "prestashop"
    port     = 3306
  }
}

output "prestashop_url" {
  description = "PrestaShop application URL"
  value       = module.prestashop.prestashop_url
}

