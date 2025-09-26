@echo off
REM Script de déploiement Windows PowerShell pour Taylor Shift Infrastructure
REM Usage: deploy.bat [dev|staging|prod]

setlocal enabledelayedexpansion

REM Vérifier les paramètres
if "%1"=="" (
    echo Usage: %0 [dev^|staging^|prod]
    echo Exemples:
    echo   %0 dev      # Deploie l'environnement de developpement
    echo   %0 staging  # Deploie l'environnement de staging
    echo   %0 prod     # Deploie l'environnement de production
    exit /b 1
)

set ENVIRONMENT=%1

REM Vérifier que l'environnement est valide
if not "%ENVIRONMENT%"=="dev" if not "%ENVIRONMENT%"=="staging" if not "%ENVIRONMENT%"=="prod" (
    echo Environnement invalide: %ENVIRONMENT%
    echo Environnements supportes: dev, staging, prod
    exit /b 1
)

echo.
echo ===============================================
echo 🎵 Taylor Shift Infrastructure Deployment 🎵
echo Environnement: %ENVIRONMENT%
echo ===============================================
echo.

REM Vérifier les prérequis
echo Verification des prerequis...

REM Vérifier Terraform
terraform version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Terraform n'est pas installe ou n'est pas dans le PATH
    echo Installez Terraform: winget install Hashicorp.Terraform
    exit /b 1
)

REM Vérifier Azure CLI
az version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Azure CLI n'est pas installe ou n'est pas dans le PATH
    echo Installez Azure CLI: winget install Microsoft.AzureCLI
    exit /b 1
)

REM Vérifier la connexion Azure
az account show >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Vous n'etes pas connecte a Azure
    echo Executez 'az login' d'abord
    exit /b 1
)

echo ✅ Prerequis verifies

REM Se déplacer dans le répertoire de l'environnement
set SCRIPT_DIR=%~dp0
set ENV_DIR=%SCRIPT_DIR%environments\%ENVIRONMENT%

if not exist "%ENV_DIR%" (
    echo ERREUR: Repertoire de l'environnement non trouve: %ENV_DIR%
    exit /b 1
)

cd /d "%ENV_DIR%"
echo Repertoire de travail: %ENV_DIR%

REM Vérifier si terraform.tfvars existe
if not exist "terraform.tfvars" (
    echo AVERTISSEMENT: Le fichier terraform.tfvars n'existe pas
    if exist "terraform.tfvars.example" (
        echo Copie de terraform.tfvars.example vers terraform.tfvars
        copy terraform.tfvars.example terraform.tfvars >nul
        echo.
        echo ⚠️  IMPORTANT: Editez terraform.tfvars avec vos valeurs avant de continuer
        
        if "%ENVIRONMENT%"=="prod" (
            echo.
            echo ❌ Configuration de production incomplete. Editez terraform.tfvars d'abord!
            exit /b 1
        )
        
        set /p "continue=Voulez-vous continuer avec les valeurs par defaut? (y/N): "
        if /i not "!continue!"=="y" (
            echo Deploiement annule. Editez terraform.tfvars et relancez le script.
            exit /b 0
        )
    ) else (
        echo ERREUR: Aucun fichier de configuration trouve
        exit /b 1
    )
)

REM Avertissements spéciaux pour la production
if "%ENVIRONMENT%"=="prod" (
    echo.
    echo 🚨 DEPLOIEMENT EN PRODUCTION 🚨
    echo Ceci va deployer l'infrastructure de production pour Taylor Shift
    echo Assurez-vous que:
    echo   - Tous les mots de passe sont securises
    echo   - Les domaines sont corrects
    echo   - Les contacts d'urgence sont configures
    echo   - Le webhook Slack/Teams fonctionne
    echo.
    set /p "confirm=Etes-vous sur de vouloir continuer? (tapez 'DEPLOY' pour confirmer): "
    if not "!confirm!"=="DEPLOY" (
        echo Deploiement de production annule
        exit /b 0
    )
)

echo.
echo Initialisation de Terraform...
terraform init
if errorlevel 1 (
    echo ERREUR: Echec de l'initialisation Terraform
    exit /b 1
)

echo.
echo Validation de la configuration Terraform...
terraform validate
if errorlevel 1 (
    echo ERREUR: Configuration Terraform invalide
    exit /b 1
)

echo.
echo Generation du plan de deploiement...
set PLAN_FILE=%ENVIRONMENT%.tfplan

terraform plan -out="%PLAN_FILE%"
if errorlevel 1 (
    echo ERREUR: Echec de la generation du plan Terraform
    exit /b 1
)

REM Confirmation avant apply
if "%ENVIRONMENT%"=="prod" (
    echo.
    echo Derniere chance d'annuler le deploiement de production
    set /p "final_confirm=Appliquer les changements en PRODUCTION? (tapez 'YES' pour confirmer): "
    if not "!final_confirm!"=="YES" (
        echo Deploiement annule
        if exist "%PLAN_FILE%" del "%PLAN_FILE%"
        exit /b 0
    )
) else (
    echo.
    set /p "apply=Appliquer les changements? (y/N): "
    if /i not "!apply!"=="y" (
        echo Deploiement annule
        if exist "%PLAN_FILE%" del "%PLAN_FILE%"
        exit /b 0
    )
)

echo.
echo Application des changements Terraform...
terraform apply "%PLAN_FILE%"
if errorlevel 1 (
    echo ❌ Echec du deploiement Terraform
    if exist "%PLAN_FILE%" del "%PLAN_FILE%"
    exit /b 1
)

echo.
echo ====================================
echo 🎉 DEPLOIEMENT TERMINE AVEC SUCCES!
echo ====================================
echo.

REM Affichage des outputs importants
echo Recuperation des informations de deploiement...
echo.
echo ======================================
echo 📋 INFORMATIONS DE DEPLOIEMENT
echo ======================================

terraform output prestashop_url 2>nul >nul
if not errorlevel 1 (
    for /f "delims=" %%i in ('terraform output -raw prestashop_url 2^>nul') do set PRESTASHOP_URL=%%i
    echo 🌐 URL PrestaShop: !PRESTASHOP_URL!
)

echo.
echo ======================================
echo 📊 ETAPES SUIVANTES
echo ======================================

if "%ENVIRONMENT%"=="dev" (
    echo ✅ Environnement de developpement pret
    echo 🔗 Accedez a votre application via l'URL ci-dessus
    echo 🔧 Configurez PrestaShop via l'interface web
)

if "%ENVIRONMENT%"=="staging" (
    echo ✅ Environnement de staging pret
    echo 🧪 Effectuez vos tests de charge
    echo 📊 Surveillez les metriques dans Azure Monitor
)

if "%ENVIRONMENT%"=="prod" (
    echo ✅ Environnement de PRODUCTION deploye
    echo 🚨 Surveillez les alertes dans les prochaines minutes
    echo 📈 Verifiez le dashboard de monitoring
    echo 🔒 Configurez le domaine personnalise si necessaire
)

echo.
echo 📖 Documentation complete: README.md
echo 🆘 Support: admin@taylorshift.com

REM Nettoyage
if exist "%PLAN_FILE%" del "%PLAN_FILE%"

echo.
echo 🎵 Infrastructure Taylor Shift deployee avec succes! 🎵
echo.

endlocal