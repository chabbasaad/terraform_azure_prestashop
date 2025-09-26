#!/bin/bash

# Script de déploiement automatisé pour Taylor Shift Infrastructure
# Usage: ./deploy.sh [dev|staging|prod]

set -e

# Couleurs pour la sortie
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Vérifier les paramètres
if [ $# -eq 0 ]; then
    error "Usage: $0 [dev|staging|prod]"
    echo "Exemples:"
    echo "  $0 dev      # Déploie l'environnement de développement"
    echo "  $0 staging  # Déploie l'environnement de staging"
    echo "  $0 prod     # Déploie l'environnement de production"
    exit 1
fi

ENVIRONMENT=$1

# Vérifier que l'environnement est valide
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    error "Environnement invalide: $ENVIRONMENT"
    error "Environnements supportés: dev, staging, prod"
    exit 1
fi

log "🎵 Déploiement de l'infrastructure Taylor Shift - Environnement: $ENVIRONMENT"

# Vérifier les prérequis
log "Vérification des prérequis..."

# Vérifier Terraform
if ! command -v terraform &> /dev/null; then
    error "Terraform n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Vérifier Azure CLI
if ! command -v az &> /dev/null; then
    error "Azure CLI n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Vérifier la connexion Azure
if ! az account show &> /dev/null; then
    error "Vous n'êtes pas connecté à Azure. Exécutez 'az login' d'abord."
    exit 1
fi

success "Prérequis vérifiés"

# Se déplacer dans le répertoire de l'environnement
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="$SCRIPT_DIR/environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    error "Répertoire de l'environnement non trouvé: $ENV_DIR"
    exit 1
fi

cd "$ENV_DIR"
log "Répertoire de travail: $ENV_DIR"

# Vérifier si terraform.tfvars existe
if [ ! -f "terraform.tfvars" ]; then
    warning "Le fichier terraform.tfvars n'existe pas"
    if [ -f "terraform.tfvars.example" ]; then
        log "Copie de terraform.tfvars.example vers terraform.tfvars"
        cp terraform.tfvars.example terraform.tfvars
        warning "⚠️  IMPORTANT: Éditez terraform.tfvars avec vos valeurs avant de continuer"
        
        if [ "$ENVIRONMENT" = "prod" ]; then
            error "❌ Configuration de production incomplète. Éditez terraform.tfvars d'abord!"
            exit 1
        fi
        
        read -p "Voulez-vous continuer avec les valeurs par défaut? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Déploiement annulé. Éditez terraform.tfvars et relancez le script."
            exit 0
        fi
    else
        error "Aucun fichier de configuration trouvé"
        exit 1
    fi
fi

# Avertissements spéciaux pour la production
if [ "$ENVIRONMENT" = "prod" ]; then
    warning "🚨 DÉPLOIEMENT EN PRODUCTION 🚨"
    warning "Ceci va déployer l'infrastructure de production pour Taylor Shift"
    warning "Assurez-vous que:"
    warning "  - Tous les mots de passe sont sécurisés"
    warning "  - Les domaines sont corrects"
    warning "  - Les contacts d'urgence sont configurés"
    warning "  - Le webhook Slack/Teams fonctionne"
    
    read -p "Êtes-vous sûr de vouloir continuer? (tapez 'DEPLOY' pour confirmer): " confirm
    if [ "$confirm" != "DEPLOY" ]; then
        log "Déploiement de production annulé"
        exit 0
    fi
fi

# Initialisation Terraform
log "Initialisation de Terraform..."
if ! terraform init; then
    error "Échec de l'initialisation Terraform"
    exit 1
fi

# Validation de la configuration
log "Validation de la configuration Terraform..."
if ! terraform validate; then
    error "Configuration Terraform invalide"
    exit 1
fi

# Plan Terraform
log "Génération du plan de déploiement..."
PLAN_FILE="$ENVIRONMENT.tfplan"

if ! terraform plan -out="$PLAN_FILE"; then
    error "Échec de la génération du plan Terraform"
    exit 1
fi

# Confirmation avant apply
if [ "$ENVIRONMENT" = "prod" ]; then
    warning "Dernière chance d'annuler le déploiement de production"
    read -p "Appliquer les changements en PRODUCTION? (tapez 'YES' pour confirmer): " final_confirm
    if [ "$final_confirm" != "YES" ]; then
        log "Déploiement annulé"
        rm -f "$PLAN_FILE"
        exit 0
    fi
else
    read -p "Appliquer les changements? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Déploiement annulé"
        rm -f "$PLAN_FILE"
        exit 0
    fi
fi

# Application des changements
log "Application des changements Terraform..."
START_TIME=$(date +%s)

if terraform apply "$PLAN_FILE"; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    success "🎉 Déploiement terminé avec succès!"
    log "Durée du déploiement: ${DURATION}s"
    
    # Affichage des outputs importants
    log "Récupération des informations de déploiement..."
    
    echo
    echo "======================================"
    echo "📋 INFORMATIONS DE DÉPLOIEMENT"
    echo "======================================"
    
    if terraform output prestashop_url &> /dev/null; then
        PRESTASHOP_URL=$(terraform output -raw prestashop_url 2>/dev/null || echo "Non disponible")
        echo "🌐 URL PrestaShop: $PRESTASHOP_URL"
    fi
    
    if terraform output admin_access &> /dev/null; then
        echo "👤 Accès administrateur:"
        terraform output admin_access 2>/dev/null || echo "  Non disponible"
    fi
    
    echo
    echo "======================================"
    echo "📊 ÉTAPES SUIVANTES"
    echo "======================================"
    
    case $ENVIRONMENT in
        dev)
            echo "✅ Environnement de développement prêt"
            echo "🔗 Accédez à votre application via l'URL ci-dessus"
            echo "🔧 Configurez PrestaShop via l'interface web"
            ;;
        staging)
            echo "✅ Environnement de staging prêt"
            echo "🧪 Effectuez vos tests de charge"
            echo "📊 Surveillez les métriques dans Azure Monitor"
            ;;
        prod)
            echo "✅ Environnement de PRODUCTION déployé"
            echo "🚨 Surveillez les alertes dans les prochaines minutes"
            echo "📈 Vérifiez le dashboard de monitoring"
            echo "🔒 Configurez le domaine personnalisé si nécessaire"
            ;;
    esac
    
    echo
    echo "📖 Documentation complète: README.md"
    echo "🆘 Support: admin@taylorshift.com"
    
    # Nettoyage
    rm -f "$PLAN_FILE"
    
else
    error "❌ Échec du déploiement Terraform"
    rm -f "$PLAN_FILE"
    exit 1
fi

success "🎵 Infrastructure Taylor Shift déployée avec succès! 🎵"