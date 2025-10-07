locals {
  environment = "prod"
  project     = "taylor-shift"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "taylor-shift-team"
    CostCenter  = "taylor-shift-concerts"
  }

  config = {
    # Configuration MySQL optimisée (D2ds_v4 au lieu de D4ds_v4)
  db_sku              = "B_Standard_B1ms"  # Compatible Azure for Students/dev/staging
    db_storage_gb       = 128                     # 128 GB (au lieu de 512 GB)
    db_backup_retention = 7                       # 7 jours (au lieu de 35)

    # Configuration Container Apps optimisée
    min_replicas = 2   # 2 replicas minimum (au lieu de 5)
    max_replicas = 10  # 10 replicas maximum (au lieu de 50)
    cpu_limit    = 1.0 # 1 CPU par replica (au lieu de 2.0)
    memory_limit = "2Gi" # 2Gi par replica (au lieu de 4Gi)

    # Monitoring
    enable_monitoring = false  # Simplifié (Application Insights suffit)

    # Autoscaling
    concurrent_requests_threshold = 10  # Scale à 10 requêtes concurrentes
  }
}