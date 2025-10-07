# Variables pour l'environnement de production Taylor Shift
# Configuration sécurisée et haute performance

variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
  default     = "West Europe"
}

variable "subscription_id" {
  description = "ID de la subscription Azure"
  type        = string
}

# Variables de base de données (sécurisées)
variable "db_admin_user" {
  description = "Nom d'utilisateur administrateur pour la base de données"
  type        = string
  default     = "tayloradmin"
}

variable "db_password" {
  description = "Mot de passe pour la base de données (doit être très sécurisé)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Le mot de passe doit contenir au moins 8 caractères."
  }
}

# Variables PrestaShop
variable "admin_email" {
  description = "Email de l'administrateur pour PrestaShop et les notifications"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "L'email doit être au format valide."
  }
}

variable "prestashop_admin_password" {
  description = "Mot de passe de l'administrateur PrestaShop (doit être sécurisé)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.prestashop_admin_password) >= 8
    error_message = "Le mot de passe PrestaShop doit contenir au moins 8 caractères."
  }
}

# Variables de monitoring et alertes (pour usage futur)
# Ces variables sont préparées pour des fonctionnalités avancées