# =============================================================================
# SCRIPT: CONFIGURE KUBECTL
# =============================================================================
# Este script configura kubectl para acceder al clúster AKS desplegado
#
# PREREQUISITOS:
# - Azure CLI instalado
# - kubectl instalado
# - Clúster AKS desplegado con Terraform
#
# USO:
#   .\configure-kubectl.ps1 -Environment dev

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "stage", "prod")]
    [string]$Environment
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  KUBECTL CONFIGURATION" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------
$RootDir = Split-Path -Parent $PSScriptRoot
$EnvDir = Join-Path $RootDir "environments\$Environment"

# -----------------------------------------------------------------------------
# VERIFICACIONES
# -----------------------------------------------------------------------------
Write-Host "Verificando prerequisitos..." -ForegroundColor Yellow

# Verificar Azure CLI
try {
    $account = az account show 2>$null | ConvertFrom-Json
    Write-Host "✓ Azure CLI: Sesión activa" -ForegroundColor Green
} catch {
    Write-Host "ERROR: No hay sesión activa de Azure CLI" -ForegroundColor Red
    Write-Host "Ejecuta: az login" -ForegroundColor Yellow
    exit 1
}

# Verificar kubectl
try {
    kubectl version --client --short 2>$null | Out-Null
    Write-Host "✓ kubectl instalado" -ForegroundColor Green
} catch {
    Write-Host "ERROR: kubectl no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""

# -----------------------------------------------------------------------------
# OBTENER INFORMACIÓN DEL CLÚSTER
# -----------------------------------------------------------------------------
Write-Host "Obteniendo información del clúster desde Terraform..." -ForegroundColor Yellow

Set-Location $EnvDir

$rgName = terraform output -raw resource_group_name 2>$null
$clusterName = terraform output -raw aks_cluster_name 2>$null

if (-not $rgName -or -not $clusterName) {
    Write-Host "ERROR: No se pudieron obtener los outputs de Terraform" -ForegroundColor Red
    Write-Host "Asegúrate de que el despliegue se haya completado exitosamente" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Resource Group: $rgName" -ForegroundColor Green
Write-Host "✓ Cluster Name:   $clusterName" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# CONFIGURAR KUBECTL
# -----------------------------------------------------------------------------
Write-Host "Configurando kubectl..." -ForegroundColor Yellow

az aks get-credentials `
    --resource-group $rgName `
    --name $clusterName `
    --overwrite-existing

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo configurar kubectl" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✓ kubectl configurado exitosamente" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# VERIFICAR CONEXIÓN
# -----------------------------------------------------------------------------
Write-Host "Verificando conexión al clúster..." -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

Write-Host ""
Write-Host "Contexto actual:" -ForegroundColor Cyan
kubectl config current-context

Write-Host ""
Write-Host "Nodos del clúster:" -ForegroundColor Cyan
kubectl get nodes

Write-Host ""
Write-Host "Namespaces:" -ForegroundColor Cyan
kubectl get namespaces

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  CONFIGURACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Comandos útiles:" -ForegroundColor Yellow
Write-Host "  kubectl get nodes                     # Ver nodos del clúster" -ForegroundColor Gray
Write-Host "  kubectl get pods --all-namespaces     # Ver todos los pods" -ForegroundColor Gray
Write-Host "  kubectl get services --all-namespaces # Ver todos los servicios" -ForegroundColor Gray
Write-Host "  kubectl cluster-info                  # Información del clúster" -ForegroundColor Gray
Write-Host ""
