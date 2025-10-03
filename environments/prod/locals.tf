locals {
  environment = "prod"
  project     = "taylor-shift"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "taylor-shift-team"
    CostCenter  = "taylor-shift-concerts"
    Compliance  = "required"
  }

  config = {
    db_sku              = "GP_Standard_D4ds_v4"
    db_storage_gb       = 512
    db_backup_retention = 35

    min_replicas = 5
    max_replicas = 50
    cpu_limit    = 2.0
    memory_limit = "4Gi"


    enable_monitoring = true

    enable_vnet = true
    enable_private_dns = true

    concurrent_requests_threshold = 5
    autoscaling_response_time = "30s"
  }
}