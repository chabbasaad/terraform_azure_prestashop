# Simplified Variables for Dev Environment

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "France Central"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Database variables
variable "db_admin_user" {
  description = "Database administrator username"
  type        = string
  default     = "tayloradmin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default     = "TaylorShift2025!Dev"

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
}

# PrestaShop variables
variable "admin_email" {
  description = "PrestaShop admin email"
  type        = string
  default     = "admin@taylorshift-dev.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "Email must be in valid format."
  }
}

variable "prestashop_admin_password" {
  description = "PrestaShop admin password"
  type        = string
  sensitive   = true
  default     = "TaylorAdmin2025!"

  validation {
    condition     = length(var.prestashop_admin_password) >= 8
    error_message = "PrestaShop admin password must be at least 8 characters long."
  }
}
