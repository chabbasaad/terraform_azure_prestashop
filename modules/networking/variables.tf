variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "enable_vnet" {
  description = "Active la création d'un VNet (recommandé pour production)"
  type        = bool
  default     = false
}

variable "vnet_address_space" {
  description = "Espace d'adressage du VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_apps_subnet_address" {
  description = "Plage d'adresses pour le subnet Container Apps"
  type        = string
  default     = "10.0.1.0/24"
}

variable "database_subnet_address" {
  description = "Plage d'adresses pour le subnet de la base de données"
  type        = string
  default     = "10.0.2.0/24"
}

variable "enable_private_dns" {
  description = "Active le DNS privé pour la base de données"
  type        = bool
  default     = false
}