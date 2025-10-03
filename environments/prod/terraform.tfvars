# Exemple de fichier terraform.tfvars pour l'environnement de production
# ⚠️ ATTENTION : Ceci est un environnement de PRODUCTION
# Copier ce fichier vers terraform.tfvars et modifier TOUTES les valeurs

# Configuration de base
location = "West Europe"
subscription_id = "VOTRE_SUBSCRIPTION_ID"  # ⚠️ OBLIGATOIRE : Remplacer par votre subscription

# Configuration de la base de données (SÉCURISÉ)
db_admin_user = "tayloradmin"
db_password = "VOTRE_MOT_DE_PASSE_SECURISE_16_CHARS+"  # ⚠️ OBLIGATOIRE : Très sécurisé

# Configuration PrestaShop
admin_email = "admin@taylorshift.com"  # ⚠️ OBLIGATOIRE : Votre email professionnel
prestashop_admin_password = "VOTRE_MOT_DE_PASSE_ADMIN_16_CHARS+"  # ⚠️ OBLIGATOIRE

# Configuration DockerHub (OBLIGATOIRE en production)
dockerhub_username = "VOTRE_USERNAME_DOCKERHUB"  # ⚠️ OBLIGATOIRE
dockerhub_password = "VOTRE_TOKEN_DOCKERHUB"     # ⚠️ OBLIGATOIRE : Utiliser un token

# Configuration du domaine
production_domain = "tickets.taylorshift.com"  # Votre domaine de production

# Configuration des alertes (OBLIGATOIRE)
webhook_url = "https://hooks.slack.com/services/VOTRE/WEBHOOK/URL"  # ⚠️ OBLIGATOIRE
emergency_contacts = [
  "admin@taylorshift.com",
  "ops@taylorshift.com",
  "security@taylorshift.com"
]

# Configuration de sécurité
allowed_ip_ranges = [
  "VOTRE_IP_BUREAU/32",     # IP de votre bureau
  "AUTRE_IP_AUTORISEE/32"   # Autres IPs autorisées pour l'admin
]

# Configuration avancée (recommandé)
enable_backup_encryption = true
backup_retention_years = 7
enable_cdn = true
enable_waf = true
ssl_certificate_source = "azure_managed"  # ou "custom" si vous avez un certificat