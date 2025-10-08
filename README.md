# Taylor Shift's Ticket Shop - Infrastructure Deployment

<div align="center">
  <img src="https://newsroom.ionis-group.com/wp-content/uploads/2020/11/supinfo-logo-2020-blanc-png.png" alt="SUPINFO Logo" width="200"/>

  ### Project Team 5HASH
  **5HASH :** Saad Chabba - Hamza Belyahiaoui - Constant Alberola
</div>

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Container Apps  │    │  MySQL Database │    │   Monitoring    │
│   (PrestaShop)  │───▶│ (Flexible Server)│───▶│  & Alertes      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Redis Cache   │    │ Application     │    │   Log Analytics │
│   (Production)  │    │   Insights      │    │   Workspace     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription active

### Deployment Commands

**Step 1:** Connect to Azure with your account

```bash
# 1. Clone and setup
git clone <repository-url>
cd terraform_azure_prestashop

# 2. Configure Azure
az login
```

![Azure Login](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/az_login.png)

**Step 2:** Set your subscription

```bash
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

![Azure Subscription](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/subscription_azure.png)

**Step 3:** Deploy environments

```bash
# Deploy Development Environment
cd environments/dev && terraform init && terraform apply

# Deploy Staging Environment
cd ../staging && terraform init && terraform apply  

# Deploy Production Environment
cd ../prod && terraform init && terraform apply
```


![Development Environment](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/dev_env.png)


## 🔧 Environment Configuration

Each environment has its own `terraform.tfvars` file located in `environments/{dev,staging,prod}/`. Update these files with your specific configurations such as database credentials and admin emails.

> **📝 Configuration Files:**
> - `environments/dev/terraform.tfvars` - Development environment settings
> - `environments/staging/terraform.tfvars` - Staging environment settings  
> - `environments/prod/terraform.tfvars` - Production environment settings


## 🔗 Application Access Example & Credentials

### 🧪 Development Environment
- **Application URL**: `https://prestashop-dev-XXXXXXXX.region.azurecontainerapps.io`
- **Admin Portal**: `https://prestashop-dev-XXXXXXXX.region.azurecontainerapps.io/adminportal`
- **Admin Email**: `admin@taylorshift-dev.com`
- **Admin Password**: `TaylorAdmin2025!Dev`
- **Database Host**: Available in Terraform outputs
- **Database User**: `tayloradmin`
- **Database Password**: `TaylorShift2025!Dev`

### 🔄 Staging Environment
- **Application URL**: `https://prestashop-staging-XXXXXXXX.region.azurecontainerapps.io`
- **Admin Portal**: `https://prestashop-staging-XXXXXXXX.region.azurecontainerapps.io/adminportal`
- **Admin Email**: `admin@taylorshift.com`
- **Admin Password**: `TaylorShift2025!Admin`
- **Database Host**: Available in Terraform outputs
- **Database User**: `tayloradmin`
- **Database Password**: `TaylorShift2025!Admin`

### 🎯 Production Environment
- **Application URL**: `https://prestashop-prod-XXXXXXXX.region.azurecontainerapps.io`
- **Admin Portal**: `https://prestashop-prod-XXXXXXXX.region.azurecontainerapps.io/adminportal`
- **Admin Email**: `admin@taylorshift.com`
- **Admin Password**: `TaylorShift2025!ProdAdmin`
- **Database Host**: Available in Terraform outputs
- **Database User**: `tayloradmin`
- **Database Password**: `TaylorShift2025!ProdAdmin`

> **Note**: The admin folder is automatically renamed to `adminportal` for security. Replace `XXXXXXXX` with your actual Container App suffix.

### Getting Actual URLs After Deployment

```bash
# Get Container App URL for each environment
cd environments/dev
terraform output container_app_url

cd ../staging  
terraform output container_app_url

cd ../prod
terraform output container_app_url
```

> **🔍 Note:** Replace `XXXXXXXX` in the URLs above with your actual Container App suffix from the Terraform outputs.


## 📊 Performance Benchmarks

### Running Load Tests

**Step 1:** Open your Azure CLI and run the benchmark command

![Shell Command for Benchmark](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/shell_command_for_benchmark.png)

```bash
# Run load test with 500 concurrent requests
seq 1 500 | xargs -Iname -P10 curl "YOUR_PRESTASHOP_URL"
```

![Command Benchmark Requests](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/command_benchmark_requests.png)

### Monitoring Performance Metrics

After running the benchmark, you can check the metrics to verify replica scaling:

**Before Benchmark:**
![Before Benchmark](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/prestashop_replicas.png)

**After Benchmark:**
![After Benchmark](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/replicas_started.png)

**Replica State Changes:**
![Replicas State Changes](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/replicas_state_changes.png)

**request State Changes:**
![Replicas State Changes](https://raw.githubusercontent.com/chabbasaad/terraform_azure_prestashop/main/images_terraform_guid/request_dashboard_metrics.png)



---


