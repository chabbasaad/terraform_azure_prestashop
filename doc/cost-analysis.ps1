# Script d'analyse des coûts Taylor Shift Infrastructure
# Génère un rapport de coûts pour l'estimation budgétaire

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [int]$ConcurrentUsers = 100,
    
    [Parameter(Mandatory=$false)]
    [int]$HoursPerDay = 8,
    
    [Parameter(Mandatory=$false)]
    [int]$DaysPerMonth = 22
)

Write-Host "🎵 Taylor Shift - Analyse des coûts Infrastructure" -ForegroundColor Cyan
Write-Host "Environnement: $Environment" -ForegroundColor Yellow
Write-Host "Utilisateurs simultanés: $ConcurrentUsers" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan

# Configuration des coûts par environnement (prix mensuels en EUR)
$CostConfigs = @{
    "dev" = @{
        "ContainerApps" = 20
        "Database" = 25
        "KeyVault" = 2
        "Monitoring" = 10
        "Storage" = 5
        "Networking" = 0
        "MaxReplicas" = 3
        "DatabaseSKU" = "B_Standard_B1ms"
        "ExpectedUsers" = 50
    }
    "staging" = @{
        "ContainerApps" = 150
        "Database" = 200
        "KeyVault" = 5
        "Monitoring" = 50
        "Storage" = 15
        "Networking" = 20
        "MaxReplicas" = 8
        "DatabaseSKU" = "GP_Standard_D2ds_v4"
        "ExpectedUsers" = 500
    }
    "prod" = @{
        "ContainerApps" = 800
        "Database" = 600
        "KeyVault" = 10
        "Monitoring" = 100
        "Storage" = 50
        "Networking" = 40
        "CDN" = 30
        "WAF" = 25
        "Backup" = 35
        "MaxReplicas" = 50
        "DatabaseSKU" = "GP_Standard_D4ds_v4"
        "ExpectedUsers" = 10000
    }
}

$config = $CostConfigs[$Environment]

Write-Host "`n📊 DÉTAIL DES COÛTS MENSUELS" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green

$totalCost = 0

foreach ($service in $config.Keys) {
    if ($service -notin @("MaxReplicas", "DatabaseSKU", "ExpectedUsers")) {
        $cost = $config[$service]
        $totalCost += $cost
        Write-Host "• $service : $cost EUR" -ForegroundColor White
    }
}

Write-Host "`n💰 COÛT TOTAL MENSUEL: $totalCost EUR" -ForegroundColor Magenta

# Calculs de performance
Write-Host "`n⚡ ANALYSE DE PERFORMANCE" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

$costPerUser = [math]::Round($totalCost / $config.ExpectedUsers, 2)
$costPerUserInput = [math]::Round($totalCost / $ConcurrentUsers, 2)

Write-Host "• Utilisateurs attendus: $($config.ExpectedUsers)" -ForegroundColor White
Write-Host "• Coût par utilisateur attendu: $costPerUser EUR" -ForegroundColor White
Write-Host "• Votre scenario ($ConcurrentUsers utilisateurs): $costPerUserInput EUR par utilisateur" -ForegroundColor Yellow

# Estimation des coûts selon l'utilisation
Write-Host "`n📈 PROJECTION SELON L'UTILISATION" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

$hourlyRate = [math]::Round($totalCost / (24 * 30), 2)
$dailyUsageCost = [math]::Round($hourlyRate * $HoursPerDay, 2)
$monthlyUsageCost = [math]::Round($dailyUsageCost * $DaysPerMonth, 2)

Write-Host "• Coût horaire: $hourlyRate EUR" -ForegroundColor White
Write-Host "• Usage quotidien ($HoursPerDay h/jour): $dailyUsageCost EUR" -ForegroundColor White
Write-Host "• Usage mensuel ($DaysPerMonth jours): $monthlyUsageCost EUR" -ForegroundColor Yellow

# Recommandations
Write-Host "`n💡 RECOMMANDATIONS" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green

switch ($Environment) {
    "dev" {
        Write-Host "• Idéal pour le développement et les tests" -ForegroundColor White
        Write-Host "• Arrêter les ressources après les heures de travail pour économiser" -ForegroundColor Yellow
        Write-Host "• Coût très abordable pour l'apprentissage" -ForegroundColor Green
    }
    "staging" {
        Write-Host "• Parfait pour les tests de charge avant production" -ForegroundColor White
        Write-Host "• Utiliser seulement pendant les phases de test" -ForegroundColor Yellow
        Write-Host "• Configuration proche de la production" -ForegroundColor Green
    }
    "prod" {
        Write-Host "• Configuration haute performance pour le concert" -ForegroundColor White
        Write-Host "• Monitoring 24/7 inclus" -ForegroundColor Green
        Write-Host "• Scaling automatique jusqu'à $($config.MaxReplicas) répliques" -ForegroundColor Green
        Write-Host "• Sauvegardes et haute disponibilité" -ForegroundColor Green
    }
}

# Comparaison avec d'autres environnements
Write-Host "`n📊 COMPARAISON DES ENVIRONNEMENTS" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

foreach ($env in @("dev", "staging", "prod")) {
    $envConfig = $CostConfigs[$env]
    $envTotal = 0
    foreach ($service in $envConfig.Keys) {
        if ($service -notin @("MaxReplicas", "DatabaseSKU", "ExpectedUsers")) {
            $envTotal += $envConfig[$service]
        }
    }
    $envCostPerUser = [math]::Round($envTotal / $envConfig.ExpectedUsers, 2)
    
    if ($env -eq $Environment) {
        Write-Host "→ $env : $envTotal EUR/mois ($envCostPerUser EUR/utilisateur) ← SÉLECTIONNÉ" -ForegroundColor Yellow
    } else {
        Write-Host "  $env : $envTotal EUR/mois ($envCostPerUser EUR/utilisateur)" -ForegroundColor White
    }
}

# Tests de benchmark recommandés
Write-Host "`n🧪 TESTS DE BENCHMARK RECOMMANDÉS" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

switch ($Environment) {
    "dev" {
        Write-Host "• Apache Bench: ab -n 1000 -c 50 [URL]" -ForegroundColor White
        Write-Host "• Durée: 5 minutes" -ForegroundColor White
        Write-Host "• Objectif: 50 req/sec" -ForegroundColor White
    }
    "staging" {
        Write-Host "• Apache Bench: ab -n 10000 -c 500 [URL]" -ForegroundColor White
        Write-Host "• Durée: 30 minutes" -ForegroundColor White
        Write-Host "• Objectif: 500 req/sec" -ForegroundColor White
    }
    "prod" {
        Write-Host "• Load test professionnel recommandé" -ForegroundColor White
        Write-Host "• 10,000 utilisateurs simultanés" -ForegroundColor White
        Write-Host "• Durée: 60 minutes" -ForegroundColor White
        Write-Host "• Objectif: 1,000 req/sec" -ForegroundColor White
    }
}

# Estimation du ROI pour le concert
if ($Environment -eq "prod") {
    Write-Host "`n💰 ESTIMATION ROI CONCERT TAYLOR SHIFT" -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
    
    $ticketPrice = 150  # Prix moyen d'un billet
    $expectedTickets = 50000  # Nombre de billets à vendre
    $revenue = $ticketPrice * $expectedTickets
    $infrastructureCost = $totalCost * 3  # 3 mois d'infrastructure
    $roi = [math]::Round((($revenue - $infrastructureCost) / $infrastructureCost) * 100, 0)
    
    Write-Host "• Prix moyen billet: $ticketPrice EUR" -ForegroundColor White
    Write-Host "• Billets à vendre: $expectedTickets" -ForegroundColor White
    Write-Host "• Revenus attendus: $revenue EUR" -ForegroundColor Green
    Write-Host "• Coût infrastructure (3 mois): $infrastructureCost EUR" -ForegroundColor White
    Write-Host "• ROI: $roi%" -ForegroundColor Magenta
}

Write-Host "`n🎯 PROCHAINES ÉTAPES" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green
Write-Host "1. Réviser les coûts avec votre équipe" -ForegroundColor White
Write-Host "2. Configurer les alertes de budget Azure" -ForegroundColor White
Write-Host "3. Effectuer des tests de charge" -ForegroundColor White
Write-Host "4. Monitorer les coûts réels vs estimations" -ForegroundColor White

Write-Host "`n🎵 Taylor Shift vous attend! 🎵" -ForegroundColor Cyan