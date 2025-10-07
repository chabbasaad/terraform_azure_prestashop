# Module de monitoring avancé pour Taylor Shift
# Surveillance de la performance et alertes

resource "random_string" "monitoring_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.environment}-${random_string.monitoring_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Action Group pour les notifications
resource "azurerm_monitor_action_group" "main" {
  name                = "ts-alerts-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "TSAlerts"

  email_receiver {
    name          = "admin-email"
    email_address = var.admin_email
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Alert sur l'utilisation CPU de la base de données
resource "azurerm_monitor_metric_alert" "database_cpu" {
  count               = var.enable_database_alerts ? 1 : 0
  name                = "db-cpu-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.database_id]
  description         = "Database CPU usage is too high"
  severity            = var.environment == "prod" ? 1 : 2

  criteria {
    metric_namespace = "Microsoft.DBforMySQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 80 : 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Alert sur l'utilisation mémoire de la base de données
resource "azurerm_monitor_metric_alert" "database_memory" {
  count               = var.enable_database_alerts ? 1 : 0
  name                = "db-memory-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.database_id]
  description         = "Database memory usage is too high"
  severity            = var.environment == "prod" ? 1 : 2

  criteria {
    metric_namespace = "Microsoft.DBforMySQL/flexibleServers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Alert sur les connexions à la base de données
resource "azurerm_monitor_metric_alert" "database_connections" {
  count               = var.enable_database_alerts ? 1 : 0
  name                = "db-connections-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.database_id]
  description         = "Database connection count is too high"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.DBforMySQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 80 : 50
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Alert sur le temps de réponse des applications
resource "azurerm_monitor_metric_alert" "app_response_time" {
  count               = var.enable_app_alerts ? 1 : 0
  name                = "app-response-time-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.application_insights_id]
  description         = "Application response time is too high"
  severity            = var.environment == "prod" ? 1 : 2

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 2000 : 5000  # ms
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Alert sur le taux d'erreur des applications
resource "azurerm_monitor_metric_alert" "app_error_rate" {
  count               = var.enable_app_alerts ? 1 : 0
  name                = "app-error-rate-high-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.application_insights_id]
  description         = "Application error rate is too high"
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 10 : 20
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}

# Dashboard personnalisé pour Taylor Shift
resource "azurerm_portal_dashboard" "main" {
  name                = "taylor-shift-dashboard-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  dashboard_properties = templatefile("${path.module}/dashboard.json", {
    subscription_id         = var.subscription_id
    resource_group_name     = var.resource_group_name
    database_id            = var.database_id
    application_insights_id = var.application_insights_id
    container_app_id       = var.container_app_id
    environment            = var.environment
  })

  tags = {
    Environment = var.environment
    Project     = "taylor-shift"
  }
}