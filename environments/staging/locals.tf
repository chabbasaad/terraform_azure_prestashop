locals {
  environment = "staging"
  project     = "taylor-shift"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "taylor-shift-team"
  }

  config = {
    db_sku              = "GP_Standard_D2ds_v4"
    db_storage_gb       = 128
    db_backup_retention = 14
    min_replicas        = 2
    max_replicas        = 8
    cpu_limit           = 1.0
    memory_limit        = "2Gi"
    enable_monitoring   = false  # Simplified staging - no monitoring module
  }
}