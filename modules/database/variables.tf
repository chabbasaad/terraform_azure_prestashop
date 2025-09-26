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
