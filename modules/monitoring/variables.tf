variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

variable "enable_database_alerts" {
  description = "Activer les alertes pour la base de données"
  type        = bool
  default     = true
}

variable "enable_app_alerts" {
  description = "Activer les alertes pour l'application"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environnement de déploiement (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "admin_email" {
  description = "Email pour les notifications d'alerte"
  type        = string
}

variable "webhook_url" {
  description = "URL du webhook pour les notifications (Slack/Teams)"
  type        = string
  default     = ""
}

variable "database_id" {
  description = "ID de la base de données à surveiller"
  type        = string
  default     = ""
}

variable "application_insights_id" {
  description = "ID d'Application Insights"
  type        = string
  default     = ""
}

variable "container_app_id" {
  description = "ID de la Container App"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "ID de la subscription Azure"
  type        = string
}