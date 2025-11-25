# =============================================================================
# TERRAFORM BACKEND CONFIGURATION
# =============================================================================
# Este archivo configura el backend remoto para almacenar el estado de Terraform
# El estado se guarda en Azure Storage Account para permitir trabajo colaborativo
# y mantener un registro centralizado de la infraestructura
#
# IMPORTANTE: 
# - Este archivo debe ser comentado en la primera ejecución
# - Primero ejecutar el script: scripts/setup-backend.sh
# - Luego descomentar este bloque y ejecutar: terraform init -migrate-state
#
# =============================================================================

# DESCOMENTAR DESPUÉS DE CREAR EL BACKEND CON EL SCRIPT
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-state-rg"
#     storage_account_name = "tfstateecomm12345"  # DEBE SER ÚNICO GLOBALMENTE
#     container_name       = "tfstate"
#     key                  = "dev.terraform.tfstate"  # Cambiar según ambiente
#   }
# }

# =============================================================================
# CONFIGURACIÓN POR AMBIENTE
# =============================================================================
# El archivo key debe cambiar según el ambiente:
# - DEV:   key = "dev.terraform.tfstate"
# - STAGE: key = "stage.terraform.tfstate"
# - PROD:  key = "prod.terraform.tfstate"
#
# Esto permite mantener estados separados por ambiente
# =============================================================================

# =============================================================================
# AUTENTICACIÓN DEL BACKEND
# =============================================================================
# El backend usa las mismas credenciales que el provider azurerm
# Opciones de autenticación:
#
# 1. Azure CLI (Desarrollo local):
#    az login
#
# 2. Service Principal (CI/CD):
#    Definir variables de entorno:
#    ARM_CLIENT_ID
#    ARM_CLIENT_SECRET
#    ARM_SUBSCRIPTION_ID
#    ARM_TENANT_ID
#
# 3. Managed Identity (Ejecución en Azure):
#    Automática si se ejecuta desde una VM/Container con Managed Identity
# =============================================================================
