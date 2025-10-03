variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "subscription_id" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  sensitive   = true
}

variable "dockerhub_username" {
  description = "Nom d'utilisateur DockerHub"
  type        = string
}

variable "dockerhub_password" {
  description = "Mot de passe DockerHub"
  type        = string
  sensitive   = true
}

# Variables de configuration avancée
variable "custom_domain" {
  description = "Domaine personnalisé pour staging"
  type        = string
}

variable "webhook_url" {
  description = "URL webhook pour les notifications (Slack/Teams)"
  type        = string
}

# Variables de sécurité
variable "allowed_ip_ranges" {
  description = "Plages d'IP autorisées pour accéder à l'infrastructure"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # À restreindre en production
}

variable "enable_ssl_enforcement" {
  description = "Force l'utilisation de SSL"
  type        = bool
  default     = true
}

