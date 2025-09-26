# Simplified PrestaShop Module with Container Apps
# Based on working version but with Container Apps for scaling

resource "random_string" "app_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                = "ts-env-${var.environment}-${random_string.app_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Container App for PrestaShop
resource "azurerm_container_app" "prestashop" {
  name                         = "prestashop-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "prestashop"
      image  = "prestashop/prestashop:8.1-apache"
      cpu    = 0.5
      memory = "1Gi"

       env {
         name  = "DB_SERVER"
         value = var.db_host
       }
       env {
         name  = "DB_NAME"
         value = var.db_name
       }
       env {
         name  = "DB_USER"
         value = var.db_user
       }
       env {
         name  = "DB_PASSWD"
         value = var.db_password
       }
    }

    # HTTP scaling rule
    http_scale_rule {
      name                = "http-scale"
      concurrent_requests = "10"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"
    
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}
