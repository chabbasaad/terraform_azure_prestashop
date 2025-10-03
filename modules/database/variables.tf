# Database Module Variables

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "admin_user" {
  description = "Database administrator username"
  type        = string
}

variable "admin_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}
variable "db_sku_name" {
  description = "SKU de la base de données"
  type        = string
}

variable "storage_size_gb" {
  description = "Taille du stockage en Go"
  type        = number
}

variable "backup_retention_days" {
  description = "Durée de rétention des sauvegardes"
  type        = number
}

variable "enable_monitoring" {
  description = "Activer le monitoring"
  type        = bool
}

variable "action_group_id" {
  description = "ID du groupe d'action pour les alertes"
  type        = string
  default     = null
}