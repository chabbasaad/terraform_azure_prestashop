variable "location" {
  description = "Azure region for backend storage"
  type        = string
  default     = "francecentral"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "taylor-shift"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
  default     = "stterraformstatetaylorshift"
}

variable "resource_group_name" {
  description = "Name of the resource group for Terraform state"
  type        = string
  default     = "rg-terraform-state-taylor-shift"
}

variable "container_name" {
  description = "Name of the blob container for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Purpose    = "Terraform State Storage"
    ManagedBy  = "terraform"
    CreatedBy  = "taylor-shift-team"
  }
}
