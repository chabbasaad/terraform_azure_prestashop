variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "subscription_id" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  sensitive   = true
}

# Variables de configuration avancée (pour usage futur)
# Ces variables sont préparées pour des fonctionnalités avancées

