# Configuration for Terraform Backend Storage
location = "francecentral"
subscription_id = "98986790-05f9-4237-b612-4814a09270dd"

# Project configuration
project_name = "taylor-shift"

# Storage configuration
storage_account_name = "sttfstatetaylor09270dd"
resource_group_name = "rg-terraform-state-taylor-shift"
container_name = "tfstate"

# Tags
tags = {
  Purpose    = "Terraform State Storage"
  ManagedBy  = "terraform"
  CreatedBy  = "taylor-shift-team"
  Environment = "shared"
}
