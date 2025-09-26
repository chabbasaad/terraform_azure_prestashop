# Variables pour l'environnement de staging Taylor Shift

variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
  default     = "West Europe"
}

variable "subscription_id" {
  description = "ID de la subscription Azure"
  type        = string
  default     = "98986790-05f9-4237-b612-4814a09270dd"  # Remplacer par votre subscription
}

# Variables de base de données
variable "db_admin_user" {
  description = "Nom d'utilisateur administrateur pour la base de données"
  type        = string
  default     = "tayloradmin"
}

variable "db_password" {
  description = "Mot de passe pour la base de données"
  type        = string
  sensitive   = true
  default     = "TaylorShift2025!Staging"
  
  validation {
    condition     = length(var.db_password) >= 12
    error_message = "Le mot de passe doit contenir au moins 12 caractères pour staging."
  }
}

# Variables PrestaShop
variable "admin_email" {
  description = "Email de l'administrateur pour PrestaShop et les notifications"
  type        = string
  default     = "admin@taylorshift-staging.com"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "L'email doit être au format valide."
  }
}

variable "prestashop_admin_password" {
  description = "Mot de passe de l'administrateur PrestaShop"
  type        = string
  sensitive   = true
  default     = "TaylorAdmin2025!Staging"
  
  validation {
    condition     = length(var.prestashop_admin_password) >= 12
    error_message = "Le mot de passe PrestaShop doit contenir au moins 12 caractères pour staging."
  }
}

# Variables DockerHub
variable "dockerhub_username" {
  description = "Nom d'utilisateur DockerHub"
  type        = string
  default     = ""
}

variable "dockerhub_password" {
  description = "Mot de passe DockerHub"
  type        = string
  sensitive   = true
  default     = ""
}

# Variables de configuration avancée
variable "custom_domain" {
  description = "Domaine personnalisé pour staging"
  type        = string
  default     = "staging.taylorshift.com"
}

variable "webhook_url" {
  description = "URL webhook pour les notifications (Slack/Teams)"
  type        = string
  default     = ""
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