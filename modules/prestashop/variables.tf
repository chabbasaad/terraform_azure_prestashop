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

variable "admin_password" {
  description = "PrestaShop admin password"
  type        = string
  sensitive   = true
}