# 🎵 Taylor Shift - Infrastructure as Code

Infrastructure Terraform haute performance pour le système de billetterie du concert de Taylor Shift.

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![PrestaShop](https://img.shields.io/badge/PrestaShop-%23DF0067.svg?style=for-the-badge&logo=prestashop&logoColor=white)

## 📋 Vue d'ensemble

Cette infrastructure est conçue pour gérer **des milliers d'utilisateurs simultanés** lors de l'ouverture des ventes de billets. Elle utilise Azure Container Apps avec autoscaling, Azure Database for MySQL avec haute disponibilité, et un monitoring complet.

### 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Azure CDN     │    │ Container Apps  │    │  MySQL Database │
│   (Production)  │───▶│   (PrestaShop)  │───▶│ (Haute Dispo.)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Application    │    │   Key Vault     │    │   Monitoring    │
│   Gateway       │    │   (Secrets)     │    │  & Alertes      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Démarrage rapide

### Prérequis

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Subscription Azure active

### Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/hamza-bely/5HASH---Infrastructure-as-Code.git
   cd taylor-shift
   ```

2. **Configurer Azure CLI**
   ```bash
   az login
   az account set --subscription "98986790-05f9-4237-b612-4814a09270dd"
   ```

3. **Déployer l'environnement de développement**
   ```bash
   cd environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

### 🔧 Configuration par environnement

| Environnement | Replicas | CPU/Memory | Base de données | Monitoring |
|---------------|----------|------------|-----------------|------------|
| **dev**       | 1-3      | 0.5/1Gi    | B_Standard_B1ms | Basique    |
| **staging**   | 2-8      | 1.0/2Gi    | GP_Standard_D2ds_v4 | Complet |
| **prod**      | 5-50     | 2.0/4Gi    | GP_Standard_D4ds_v4 | Avancé  |

## 📁 Structure du projet

```
taylor-shift/
├── environments/          # Configurations par environnement
│   ├── dev/              # Développement (coût minimal)
│   ├── staging/          # Tests (réplique de production)
│   └── prod/             # Production (haute performance)
├── modules/              # Modules Terraform réutilisables
│   ├── database/         # Azure MySQL Flexible Server
│   ├── prestashop/       # Azure Container Apps
│   ├── secrets/          # Azure Key Vault
│   ├── monitoring/       # Azure Monitor & Alerts
│   └── networking/       # VNet & Security Groups
└── README.md            # Documentation (ce fichier)
```

## 🛠️ Modules disponibles

### 🗄️ Module Database
- **MySQL Flexible Server** avec haute disponibilité
- **Backup automatique** (7-35 jours selon l'environnement)
- **Monitoring** CPU, mémoire, connexions
- **Scaling** vertical selon la charge

### 🐳 Module PrestaShop
- **Azure Container Apps** avec autoscaling
- **1-50 répliques** selon la demande
- **Variables d'environnement** sécurisées
- **Health checks** intégrés

### 🔐 Module Secrets
- **Azure Key Vault** pour tous les secrets
- **Rotation automatique** des clés
- **Accès via identité managée**
- **Audit** complet des accès

### 📊 Module Monitoring
- **Application Insights** pour les métriques
- **Alertes automatiques** (CPU, mémoire, erreurs)
- **Dashboard** personnalisé Azure
- **Notifications** Slack/Teams

### 🌐 Module Networking
- **VNet isolé** (staging/prod)
- **Subnets dédiés** par service
- **Network Security Groups**
- **DNS privé** pour sécurité

## 🚦 Déploiement par environnement

### 🧪 Développement

```bash
cd environments/dev
cp terraform.tfvars terraform.tfvars
# Éditer terraform.tfvars avec vos valeurs
terraform init
terraform apply
```

**Accès :** `https://prestashop-dev-XXXXXXXX.region.azurecontainerapps.io`

### 🔄 Staging

```bash
cd environments/staging
cp terraform.tfvars terraform.tfvars
# Configuration proche de la production
terraform init
terraform apply
```

**Domaine :** `staging.taylorshift.com`

### 🎯 Production

```bash
cd environments/prod
cp terraform.tfvars terraform.tfvars
# ⚠️ Vérifier toutes les configurations de sécurité
terraform init
terraform plan -out=prod.tfplan
# ⚠️ Révision obligatoire du plan
terraform apply prod.tfplan
```

**Domaine :** `tickets.taylorshift.com`

## 📈 Tests de performance

### Benchmark avec Apache Bench

```bash
# Test basique (100 utilisateurs, 10 secondes)
ab -n 1000 -c 100 https://your-app-url/

# Test de charge élevée (1000 utilisateurs simultanés)
ab -n 10000 -c 1000 -t 60 https://your-app-url/
```

### Configuration recommandée pour les tests

| Métrique | Dev | Staging | Production |
|----------|-----|---------|------------|
| Utilisateurs simultanés | 50 | 500 | 10,000 |
| Durée du test | 5 min | 30 min | 60 min |
| RPS cible | 50 | 500 | 1,000 |

## 💰 Estimation des coûts

### Coût mensuel estimé (EUR)

| Service | Dev | Staging | Production |
|---------|-----|---------|------------|
| Container Apps | €20 | €150 | €800 |
| MySQL Database | €25 | €200 | €600 |
| Key Vault | €2 | €5 | €10 |
| Monitoring | €10 | €50 | €100 |
| **TOTAL** | **€57** | **€405** | **€1,510** |

### 📊 Coût par utilisateur simultané

- **Dev :** €1.14 par utilisateur
- **Staging :** €0.81 par utilisateur  
- **Production :** €0.15 par utilisateur

*Plus de charge = meilleur rapport coût/performance*

## 🔧 Variables importantes

### Variables communes

```hcl
# terraform.tfvars
location = "West Europe"
admin_email = "admin@taylorshift.com"
db_password = "VotreMotDePasseSécurisé!"
prestashop_admin_password = "AdminSécurisé!"
```

### Variables spécifiques à la production

```hcl
# Domaine personnalisé
production_domain = "tickets.taylorshift.com"

# Sécurité renforcée
enable_waf = true
enable_cdn = true
backup_retention_years = 7

# Notifications d'urgence
webhook_url = "https://hooks.slack.com/..."
emergency_contacts = ["urgence@taylorshift.com"]
```

## 🛡️ Sécurité

### Mesures implémentées

- ✅ **Chiffrement** au repos et en transit
- ✅ **Key Vault** pour tous les secrets
- ✅ **VNet isolé** en staging/production
- ✅ **WAF** et protection DDoS
- ✅ **Backup géo-redondant**
- ✅ **Identités managées** exclusivement
- ✅ **Audit logging** complet

### Conformité

- 🔒 **GDPR** compliant
- 🔒 **ISO 27001** ready
- 🔒 **SOC 2** compatible

## 📱 Monitoring et alertes

### Alertes configurées

- 🚨 **CPU > 80%** (Production) / 90% (Dev)
- 🚨 **Mémoire > 85%**
- 🚨 **Connexions DB > limite**
- 🚨 **Temps de réponse > 2s**
- 🚨 **Taux d'erreur > 1%**

### Dashboard disponible

Accès au dashboard : **Portal Azure > Monitor > Dashboards**

## 🔄 CI/CD et automatisation

### GitHub Actions (recommandé)

```yaml
# .github/workflows/deploy.yml
name: Deploy Taylor Shift Infrastructure
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
      - name: Terraform Plan
        run: terraform plan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

## 🆘 Dépannage

### Problèmes courants

**1. Erreur d'authentification Azure**
```bash
az login --use-device-code
az account set --subscription YOUR_SUBSCRIPTION_ID
```

**2. Conflit de noms de ressources**
```bash
# Les noms incluent un suffixe aléatoire automatiquement
# Si problème persiste, détruire et recréer
terraform destroy
terraform apply
```

**3. Quotas Azure dépassés**
```bash
# Vérifier les quotas
az vm list-usage --location "West Europe"
# Demander une augmentation si nécessaire
```

### Support et contact

- 📧 **Email :** support@taylorshift.com
- 🎫 **Issues :** GitHub Issues
- 📖 **Documentation :** [Azure Docs](https://docs.microsoft.com/azure/)

## 🏆 Performance attendue

### Objectifs de performance

- ⚡ **Temps de réponse :** < 200ms (99e percentile)
- 🚀 **Disponibilité :** 99.9% (production)
- 👥 **Utilisateurs simultanés :** 10,000+
- 📈 **Scaling :** < 30 secondes
- 🔄 **RTO :** < 1 heure
- 💾 **RPO :** < 15 minutes

## 📚 Ressources utiles

- [Documentation Terraform Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Container Apps](https://docs.microsoft.com/azure/container-apps/)
- [PrestaShop Docker](https://hub.docker.com/r/prestashop/prestashop)
- [Azure MySQL](https://docs.microsoft.com/azure/mysql/)

---

**🎵 Ready for Taylor Shift's concert? Let's make sure every fan gets their ticket! 🎵**