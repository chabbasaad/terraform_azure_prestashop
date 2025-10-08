locals {
  environment = "dev"
  project     = "taylor-shift"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "taylor-shift-team"
  }

  config = {
    db_sku              = "B_Standard_B1ms"
    db_storage_gb       = 128
    db_backup_retention = 14
    min_replicas        = 1
    max_replicas        = 4
    cpu_limit           = 1.0
    memory_limit        = "2Gi"
    enable_monitoring   = true
    enable_vnet         = true
  }
}