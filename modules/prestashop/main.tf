

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                = "ts-env-${var.environment}"
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

  identity {
    type = "SystemAssigned"
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "prestashop"
      image  = "prestashop/prestashop:latest"
      cpu    = 1.0
      memory = "2Gi"

    
      command = ["/bin/bash"]  
    #   args = [
    #     "-c",
    #     # client work only 
    #      "echo '=== PRESTASHOP AUTOMATED SETUP - CONTAINER APPS ===' && echo 'Configuring Apache for HTTPS headers...' && chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/ && apache2-foreground & APACHE_PID=$$! && sleep 10 && echo 'Checking PrestaShop installation status...' && (if [ -d /var/www/html/install ] && [ ! -f /var/www/html/config/settings.inc.php ]; then echo 'Starting PrestaShop installation...' && (php /var/www/html/install/index_cli.php --domain=\"$$DOMAIN_NAME\" --db_server=\"$$DB_SERVER\" --db_name=\"$$DB_NAME\" --db_user=\"$$DB_USER\" --db_password=\"$$DB_PASSWD\" --email=\"$$ADMIN_EMAIL\" --password=\"$$ADMIN_PASSWORD\" --name='TaylorShift' --country='fr' --language='fr' --ssl=1 || echo 'CLI completed with warnings') && sleep 5 && echo 'Configuring HTTPS URLs in database...' && mysql -h\"$$DB_SERVER\" -u\"$$DB_USER\" -p\"$$DB_PASSWD\" \"$$DB_NAME\" -e \"UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED'; UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED_EVERYWHERE'; UPDATE ps_shop_url SET domain='$$DOMAIN_NAME', domain_ssl='$$DOMAIN_NAME' WHERE id_shop=1;\" && echo 'HTTPS URLs configured in database' && echo 'Performing security cleanup...' && rm -rf /var/www/html/install && (mv /var/www/html/admin /var/www/html/adminportal || echo 'Admin folder already renamed') && mkdir -p /var/www/html/modules/ps_facebook && echo 'services: []' > /var/www/html/modules/ps_facebook/installer.yml && echo 'Fixed ps_facebook module' && echo 'Installation and cleanup completed!' & else echo 'PrestaShop already installed - configuring HTTPS URLs...' && mysql -h\"$$DB_SERVER\" -u\"$$DB_USER\" -p\"$$DB_PASSWD\" \"$$DB_NAME\" -e \"UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED'; UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED_EVERYWHERE'; UPDATE ps_shop_url SET domain='$$DOMAIN_NAME', domain_ssl='$$DOMAIN_NAME' WHERE id_shop=1;\" && echo 'HTTPS URLs configured in database for existing installation'; fi) && echo 'Container ready, Apache running...' && wait $$APACHE_PID"
      
    # ]     
    args = [
  "-c",
  "echo '=== PRESTASHOP AUTOMATED SETUP - CONTAINER APPS ===' && echo 'Configuring Apache for HTTPS headers...' && chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/ && apache2-foreground & APACHE_PID=$$! && sleep 10 && echo 'Checking PrestaShop installation status...' && (if [ -d /var/www/html/install ] && [ ! -f /var/www/html/config/settings.inc.php ]; then echo 'Starting PrestaShop installation...' && (php /var/www/html/install/index_cli.php --domain=\"$$DOMAIN_NAME\" --db_server=\"$$DB_SERVER\" --db_name=\"$$DB_NAME\" --db_user=\"$$DB_USER\" --db_password=\"$$DB_PASSWD\" --email=\"$$ADMIN_EMAIL\" --password=\"$$ADMIN_PASSWORD\" --name='TaylorShift' --country='fr' --language='fr' --ssl=1 || echo 'CLI completed with warnings') && sleep 5 && echo 'Configuring HTTPS URLs in database...' && mysql -h\"$$DB_SERVER\" -u\"$$DB_USER\" -p\"$$DB_PASSWD\" \"$$DB_NAME\" -e \"UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED'; UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED_EVERYWHERE'; UPDATE ps_shop_url SET domain='$$DOMAIN_NAME', domain_ssl='$$DOMAIN_NAME' WHERE id_shop=1;\" && echo 'HTTPS URLs configured in database' && echo 'Performing security cleanup...' && rm -rf /var/www/html/install && (mv /var/www/html/admin /var/www/html/adminportal || echo 'Admin folder already renamed') && mkdir -p /var/www/html/modules/ps_facebook && echo 'services: []' > /var/www/html/modules/ps_facebook/installer.yml && echo 'Fixed ps_facebook module' && echo 'Installation and cleanup completed!'; else echo 'PrestaShop already installed - configuring HTTPS URLs...' && mysql -h\"$$DB_SERVER\" -u\"$$DB_USER\" -p\"$$DB_PASSWD\" \"$$DB_NAME\" -e \"UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED'; UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED_EVERYWHERE'; UPDATE ps_shop_url SET domain='$$DOMAIN_NAME', domain_ssl='$$DOMAIN_NAME' WHERE id_shop=1;\" && echo 'HTTPS URLs configured in database for existing installation'; fi) && echo 'Final Apache HTTPS configuration...' && echo 'SetEnvIf X-Forwarded-Proto https HTTPS=on' >> /etc/apache2/sites-available/000-default.conf && apachectl graceful && echo 'Apache reloaded with HTTPS support' && echo 'Container ready, Apache running...' && wait $$APACHE_PID"
      ]
    
    # Database connection variables

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

       # Admin credentials pour installation automatique
       env {
         name  = "ADMIN_EMAIL"
         value = var.admin_email
       }
       env {
         name  = "ADMIN_PASSWORD"
         value = var.admin_password
       }
       env {
         name  = "DOMAIN_NAME"
         value = "prestashop-${var.environment}.${azurerm_container_app_environment.main.default_domain}"
       }

       # Health probes optimisées pour installation automatique
       startup_probe {
         transport               = "HTTP"
         port                   = 80
         path                   = "/"
         interval_seconds       = 30
         failure_count_threshold = 10  # Plus tolérant pendant l'installation
       }
       
       liveness_probe {
         transport               = "HTTP"
         port                   = 80
         path                   = "/"
         interval_seconds       = 30
         failure_count_threshold = 5
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
