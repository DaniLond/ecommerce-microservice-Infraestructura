# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================
# Define la versión mínima de Terraform y los providers requeridos
# Este archivo debe estar presente en la raíz del proyecto

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

# =============================================================================
# AZURE PROVIDER CONFIGURATION
# =============================================================================
# Configuración principal del provider de Azure
# AUTENTICACIÓN: Se recomienda usar 'az login' para desarrollo local
# Para pipelines CI/CD, usar Service Principal con variables de entorno:
#   ARM_CLIENT_ID
#   ARM_CLIENT_SECRET
#   ARM_SUBSCRIPTION_ID
#   ARM_TENANT_ID

provider "azurerm" {
  features {
    # Configuración de comportamiento para Resource Groups
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    # Configuración de comportamiento para Key Vault
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }

    # Configuración de comportamiento para Virtual Machines
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = false
    }
  }

}

# =============================================================================
# AZURE AD PROVIDER
# =============================================================================
# Provider para gestionar identidades y permisos en Azure Active Directory

provider "azuread" {

}

# =============================================================================
# RANDOM PROVIDER
# =============================================================================
# Provider para generar valores aleatorios (útil para nombres únicos)

provider "random" {
}
