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
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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
  skip_provider_registration = true
  subscription_id            = "027c217f-9523-4190-aa01-bbf4fed9f5f7"
  
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

  # Descomentar y configurar si se usa Service Principal
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
}

# =============================================================================
# AZURE AD PROVIDER
# =============================================================================
# Provider para gestionar identidades y permisos en Azure Active Directory

provider "azuread" {
  # Usa las mismas credenciales que azurerm
}

# =============================================================================
# RANDOM PROVIDER
# =============================================================================
# Provider para generar valores aleatorios (útil para nombres únicos)

provider "random" {
}
