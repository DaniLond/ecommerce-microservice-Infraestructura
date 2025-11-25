# =============================================================================
# SCRIPT: DEPLOY ENVIRONMENT
# =============================================================================
# Este script automatiza el despliegue completo de un ambiente con Terraform
#
# PREREQUISITOS:
# - Azure CLI instalado y configurado (az login)
# - Terraform instalado
# - Backend configurado (ejecutar setup-backend.ps1 primero)
#
# USO:
#   .\deploy-environment.ps1 -Environment dev
#   .\deploy-environment.ps1 -Environment dev -AutoApprove

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "stage", "prod")]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Destroy = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$PlanOnly = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  TERRAFORM DEPLOYMENT - $($Environment.ToUpper())" -ForegroundColor Cyan
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

# Verificar que existe el directorio del ambiente
if (-not (Test-Path $EnvDir)) {
    Write-Host "ERROR: No existe el directorio del ambiente: $EnvDir" -ForegroundColor Red
    exit 1
}

# Verificar Azure CLI
try {
    $account = az account show 2>$null | ConvertFrom-Json
    Write-Host "✓ Azure CLI: Sesión activa ($($account.name))" -ForegroundColor Green
} catch {
    Write-Host "ERROR: No hay sesión activa de Azure CLI" -ForegroundColor Red
    Write-Host "Ejecuta: az login" -ForegroundColor Yellow
    exit 1
}

# Verificar Terraform
try {
    $tfVersion = terraform version -json | ConvertFrom-Json
    Write-Host "✓ Terraform: $($tfVersion.terraform_version)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Terraform no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""

# -----------------------------------------------------------------------------
# CAMBIAR AL DIRECTORIO DEL AMBIENTE
# -----------------------------------------------------------------------------
Set-Location $EnvDir
Write-Host "Directorio de trabajo: $EnvDir" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# TERRAFORM INIT
# -----------------------------------------------------------------------------
Write-Host "Ejecutando: terraform init" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

terraform init -upgrade

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: terraform init falló" -ForegroundColor Red
    exit 1
}
Write-Host ""

# -----------------------------------------------------------------------------
# TERRAFORM VALIDATE
# -----------------------------------------------------------------------------
Write-Host "Ejecutando: terraform validate" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

terraform validate

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: terraform validate falló" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Configuración válida" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# TERRAFORM PLAN
# -----------------------------------------------------------------------------
Write-Host "Ejecutando: terraform plan" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

if ($Destroy) {
    terraform plan -destroy -out=tfplan
} else {
    terraform plan -out=tfplan
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: terraform plan falló" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Si solo es plan, terminar aquí
if ($PlanOnly) {
    Write-Host "Plan generado exitosamente. No se aplicarán cambios (modo -PlanOnly)" -ForegroundColor Yellow
    exit 0
}

# -----------------------------------------------------------------------------
# TERRAFORM APPLY
# -----------------------------------------------------------------------------
if (-not $AutoApprove) {
    Write-Host "¿Deseas aplicar estos cambios? (S/N): " -ForegroundColor Yellow -NoNewline
    $confirmation = Read-Host
    
    if ($confirmation -ne 'S' -and $confirmation -ne 's') {
        Write-Host "Operación cancelada por el usuario" -ForegroundColor Yellow
        Remove-Item tfplan -ErrorAction SilentlyContinue
        exit 0
    }
}

Write-Host ""
Write-Host "Ejecutando: terraform apply" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

terraform apply tfplan

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: terraform apply falló" -ForegroundColor Red
    exit 1
}

# Limpiar el plan
Remove-Item tfplan -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  DESPLIEGUE COMPLETADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# -----------------------------------------------------------------------------
# OBTENER OUTPUTS
# -----------------------------------------------------------------------------
Write-Host "Outputs del despliegue:" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "SIGUIENTES PASOS:" -ForegroundColor Yellow
Write-Host "1. Configura kubectl para acceder al clúster:" -ForegroundColor White

$rgName = terraform output -raw resource_group_name 2>$null
$clusterName = terraform output -raw aks_cluster_name 2>$null

if ($rgName -and $clusterName) {
    Write-Host "   az aks get-credentials --resource-group $rgName --name $clusterName" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Verifica el clúster:" -ForegroundColor White
    Write-Host "   kubectl get nodes" -ForegroundColor Gray
    Write-Host "   kubectl get namespaces" -ForegroundColor Gray
} else {
    Write-Host "   (ejecuta: terraform output configure_kubectl_command)" -ForegroundColor Gray
}

Write-Host ""
