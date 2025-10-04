
location = "francecentral"
#subscription_id = "eb10ec54-cd75-4a07-89a3-cc597b358808"  # ⚠️ OBLIGATOIRE : Remplacer par votre subscription
subscription_id ="98986790-05f9-4237-b612-4814a09270dd"
# Configuration de la base de données (SÉCURISÉ)
db_admin_user = "tayloradmin"
db_password = "TaylorShift2025!Admin"  # ⚠️ OBLIGATOIRE : Très sécurisé

# Configuration PrestaShop
admin_email = "admin@taylorshift.com"  # ⚠️ OBLIGATOIRE : Votre email professionnel
prestashop_admin_password = "TaylorShift2025!Admin"  # ⚠️ OBLIGATOIRE

# Configuration DockerHub (OBLIGATOIRE en production)
dockerhub_username = "hampza"  # ⚠️ OBLIGATOIRE
dockerhub_password = "Bandello31!!!"     # ⚠️ OBLIGATOIRE : Utiliser un token

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

custom_domain = "tickets.taylorshift.com"