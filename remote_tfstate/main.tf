# Bootstrap script to create Azure Storage Account for Terraform backend
# Run this script first before using the backend configuration

terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group for Terraform State Storage
resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.tags
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type  = "LRS"
  account_kind             = "StorageV2"
  
  # Enable versioning and soft delete for state file protection
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }
  
  # Enable HTTPS only
  https_traffic_only_enabled = true
  
  # Allow access from Azure services and trusted Microsoft services
  public_network_access_enabled = true
  
  # Enable OAuth authentication for better security
  default_to_oauth_authentication = true
  
  # Network access rules
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }
  
  tags = var.tags
}

# Container for Terraform State Files
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

# Output the storage account details
output "storage_account_name" {
  value = azurerm_storage_account.terraform_state.name
  description = "Name of the storage account for Terraform state"
}

output "container_name" {
  value = azurerm_storage_container.terraform_state.name
  description = "Name of the container for Terraform state files"
}

output "resource_group_name" {
  value = azurerm_resource_group.terraform_state.name
  description = "Name of the resource group containing the storage account"
}

output "backend_config" {
  value = {
    resource_group_name  = azurerm_resource_group.terraform_state.name
    storage_account_name = azurerm_storage_account.terraform_state.name
    container_name       = azurerm_storage_container.terraform_state.name
  }
  description = "Complete backend configuration for use in other environments"
}
