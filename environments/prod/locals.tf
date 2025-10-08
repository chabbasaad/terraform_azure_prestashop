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
    db_sku              = "GP_Standard_D2ds_v4" 
    db_storage_gb       = 128               
    db_backup_retention = 35                

    # Configuration Container Apps optimisée
    min_replicas = 2     
    max_replicas = 10   
    cpu_limit    = 2.0   
    memory_limit = "4Gi" 

    # Monitoring  (Application Insights suffit)
    enable_monitoring = false 

    # Autoscaling
    concurrent_requests_threshold = 10

    # Redis Cache Configuration
    redis = {
      capacity = 1
      family   = "C"
      sku_name = "Basic"
      public_network_access_enabled = true
      minimum_tls_version           = "1.2"
      maxmemory_policy             = "allkeys-lru"
    }
}
}