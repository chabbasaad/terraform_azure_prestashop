variable "admin_email" {
  description = "PrestaShop admin email"
  type        = string
  sensitive   = true
}

variable "prestashop_admin_password" {
  description = "PrestaShop admin password"
  type        = string
  sensitive   = true
}

variable "custom_domain" {
  description = "Custom domain for PrestaShop"
  type        = string
  default     = "localhost"
}
