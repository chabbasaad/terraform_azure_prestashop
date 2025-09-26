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

variable "db_password" {
  description = "Mot de passe pour la base de données"
  type        = string
  sensitive   = true
}

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

variable "container_app_identity_principal_id" {
  description = "Principal ID de l'identité managée des Container Apps"
  type        = string
  default     = ""
}