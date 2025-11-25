# =============================================================================
# SCRIPT: SETUP AZURE BACKEND FOR TERRAFORM STATE
# =============================================================================
# Este script crea los recursos necesarios en Azure para almacenar el estado
# de Terraform de forma remota y segura
#
# PREREQUISITOS:
# - Azure CLI instalado
# - Sesión activa en Azure (az login)
# - Permisos para crear recursos en la suscripción
#
# USO:
#   .\setup-backend.ps1
#   .\setup-backend.ps1 -StorageAccountName "customname" -Environment "dev"

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "terraform-state-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$StorageAccountName = "tfstateecomm$(Get-Random -Minimum 10000 -Maximum 99999)",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "tfstate",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$Environment = "dev"
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  TERRAFORM BACKEND SETUP" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# VERIFICAR SESIÓN DE AZURE CLI
# -----------------------------------------------------------------------------
Write-Host "Verificando sesión de Azure CLI..." -ForegroundColor Yellow
$account = az account show 2>$null | ConvertFrom-Json

if (-not $account) {
    Write-Host "ERROR: No hay sesión activa de Azure CLI" -ForegroundColor Red
    Write-Host "Por favor, ejecuta: az login" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Sesión activa: $($account.name)" -ForegroundColor Green
Write-Host "  Subscription ID: $($account.id)" -ForegroundColor Gray
Write-Host ""

# -----------------------------------------------------------------------------
# CREAR RESOURCE GROUP
# -----------------------------------------------------------------------------
Write-Host "Creando Resource Group: $ResourceGroupName" -ForegroundColor Yellow

$rgExists = az group exists --name $ResourceGroupName | ConvertFrom-Json

if ($rgExists) {
    Write-Host "✓ Resource Group ya existe" -ForegroundColor Green
} else {
    az group create --name $ResourceGroupName --location $Location --output none
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Resource Group creado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "ERROR: No se pudo crear el Resource Group" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# -----------------------------------------------------------------------------
# CREAR STORAGE ACCOUNT
# -----------------------------------------------------------------------------
Write-Host "Creando Storage Account: $StorageAccountName" -ForegroundColor Yellow

$saExists = az storage account check-name --name $StorageAccountName | ConvertFrom-Json

if (-not $saExists.nameAvailable) {
    if ($saExists.reason -eq "AlreadyExists") {
        Write-Host "✓ Storage Account ya existe" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Nombre de Storage Account no disponible: $($saExists.message)" -ForegroundColor Red
        Write-Host "Intenta con otro nombre o deja que se genere uno automático" -ForegroundColor Yellow
        exit 1
    }
} else {
    az storage account create `
        --name $StorageAccountName `
        --resource-group $ResourceGroupName `
        --location $Location `
        --sku Standard_LRS `
        --encryption-services blob `
        --https-only true `
        --min-tls-version TLS1_2 `
        --allow-blob-public-access false `
        --output none
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Storage Account creado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "ERROR: No se pudo crear el Storage Account" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# -----------------------------------------------------------------------------
# CREAR CONTAINER
# -----------------------------------------------------------------------------
Write-Host "Creando Container: $ContainerName" -ForegroundColor Yellow

$containerExists = az storage container exists `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --auth-mode login | ConvertFrom-Json

if ($containerExists.exists) {
    Write-Host "✓ Container ya existe" -ForegroundColor Green
} else {
    az storage container create `
        --name $ContainerName `
        --account-name $StorageAccountName `
        --auth-mode login `
        --output none
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Container creado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "ERROR: No se pudo crear el Container" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# -----------------------------------------------------------------------------
# CONFIGURACIÓN COMPLETADA
# -----------------------------------------------------------------------------
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  BACKEND CONFIGURADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Configuración del backend:" -ForegroundColor Cyan
Write-Host "  Resource Group:    $ResourceGroupName" -ForegroundColor White
Write-Host "  Storage Account:   $StorageAccountName" -ForegroundColor White
Write-Host "  Container:         $ContainerName" -ForegroundColor White
Write-Host "  Location:          $Location" -ForegroundColor White
Write-Host ""
Write-Host "SIGUIENTES PASOS:" -ForegroundColor Yellow
Write-Host "1. Actualiza el archivo backend.tf con esta configuración:" -ForegroundColor White
Write-Host ""
Write-Host "   terraform {" -ForegroundColor Gray
Write-Host "     backend `"azurerm`" {" -ForegroundColor Gray
Write-Host "       resource_group_name  = `"$ResourceGroupName`"" -ForegroundColor Gray
Write-Host "       storage_account_name = `"$StorageAccountName`"" -ForegroundColor Gray
Write-Host "       container_name       = `"$ContainerName`"" -ForegroundColor Gray
Write-Host "       key                  = `"$Environment.terraform.tfstate`"" -ForegroundColor Gray
Write-Host "     }" -ForegroundColor Gray
Write-Host "   }" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Navega al directorio del ambiente:" -ForegroundColor White
Write-Host "   cd environments/$Environment" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Inicializa Terraform:" -ForegroundColor White
Write-Host "   terraform init" -ForegroundColor Gray
Write-Host ""
