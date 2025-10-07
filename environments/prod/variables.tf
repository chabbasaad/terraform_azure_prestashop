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

# Variables DockerHub (optionnelles)
variable "dockerhub_username" {
  description = "Nom d'utilisateur DockerHub (optionnel)"
  type        = string
  default     = ""
}

variable "dockerhub_password" {
  description = "Mot de passe DockerHub (optionnel)"
  type        = string
  sensitive   = true
  default     = ""
}

# Variables de domaine
variable "production_domain" {
  description = "Domaine de production pour Taylor Shift"
  type        = string
  default     = "tickets.taylorshift.com"
}

# Variables de monitoring et alertes
variable "webhook_url" {
  description = "URL webhook pour les notifications critiques (Slack/Teams)"
  type        = string
  default     = ""
}

variable "emergency_contacts" {
  description = "Liste des contacts d'urgence pour les alertes critiques"
  type        = list(string)
  default     = ["admin@taylorshift.com", "ops@taylorshift.com"]
  
  validation {
    condition     = length(var.emergency_contacts) >= 2
    error_message = "Au moins 2 contacts d'urgence sont requis en production."
  }
}

# Variables de sécurité
variable "allowed_ip_ranges" {
  description = "Plages d'IP autorisées pour l'administration (très restreint en production)"
  type        = list(string)
  default     = []  # À définir selon les besoins de sécurité
}

variable "enable_backup_encryption" {
  description = "Active le chiffrement des sauvegardes"
  type        = bool
  default     = true
}

variable "backup_retention_years" {
  description = "Durée de rétention des sauvegardes en années"
  type        = number
  default     = 7
  
  validation {
    condition     = var.backup_retention_years >= 1
    error_message = "La rétention des sauvegardes doit être d'au moins 1 an en production."
  }
}

# Variables de performance
variable "enable_cdn" {
  description = "Active Azure CDN pour optimiser les performances globales"
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Active Web Application Firewall pour la sécurité"
  type        = bool
  default     = true
}

variable "ssl_certificate_source" {
  description = "Source du certificat SSL (azure_managed, custom, lets_encrypt)"
  type        = string
  default     = "azure_managed"
  
  validation {
    condition     = contains(["azure_managed", "custom", "lets_encrypt"], var.ssl_certificate_source)
    error_message = "La source du certificat SSL doit être azure_managed, custom ou lets_encrypt."
  }
}