#  Taylor Shift's Ticket Shop - Infrastructure Deployment

<div align="center">
  <img src="https://newsroom.ionis-group.com/wp-content/uploads/2020/11/supinfo-logo-2020-blanc-png.png" alt="SUPINFO Logo" width="200"/>

  ### Project Team 5H
  **5HASH :** Saad Chabba - Hamza Belyahiaoui - Constant Alberola
</div>

**Team:**  
  

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

## 🔗 Application Access & Credentials

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

## 🚀 Quick Start

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription active

### Deployment Commands

```bash
# 1. Clone and setup
git clone <repository-url>
cd terraform_azure_prestashop

# 2. Configure Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# 3. Deploy environments
cd environments/dev && terraform init && terraform apply
cd ../staging && terraform init && terraform apply  
cd ../prod && terraform init && terraform apply
```

## 🔧 Environment Configuration

| Environment | Purpose | Resources | Cost/Month | Capacity |
|-------------|---------|-----------|------------|----------|
| **dev** | Development & Testing | Container Apps + MySQL | €40 | 50 users |
| **staging** | Pre-production Testing | Container Apps + MySQL + Monitoring | €235 | 200 users |
| **prod** | Production Ticket Sales | Container Apps + MySQL + Redis + Monitoring | €85 | 500+ users |



### Performance Benchmarks

```bash
open your azure cli : 

run this command : seq 1 500 | xargs -Iname -P10 curl "url of prestashop  " "

```


