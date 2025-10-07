# PrestaShop Module Variables

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

variable "db_host" {
  description = "Database hostname"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "admin_email" {
  description = "PrestaShop admin email"
  type        = string
}

# Log analytics variable removed for faster dev deployment

variable "admin_password" {
  description = "PrestaShop admin password"
  type        = string
  sensitive   = true
}

variable "min_replicas" {
  type        = number
  description = "Nombre minimum de réplicas"
  default     = 1
}

variable "max_replicas" {
  type        = number
  description = "Nombre maximum de réplicas"
  default     = 3
}

variable "cpu_limit" {
  type        = number
  description = "Limite CPU"
  default     = 0.5
}

variable "memory_limit" {
  type        = string
  description = "Limite mémoire"
  default     = "1Gi"
}

variable "enable_autoscaling" {
  type        = bool
  description = "Activer l'autoscaling"
  default     = true
}

variable "concurrent_requests_threshold" {
  type        = number
  description = "Seuil de requêtes concurrentes"
  default     = 10
}

variable "domain_name" {
  type        = string
  description = "Nom de domaine personnalisé"
  default     = ""
}