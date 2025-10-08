variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "subscription_id" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  sensitive   = true
}



