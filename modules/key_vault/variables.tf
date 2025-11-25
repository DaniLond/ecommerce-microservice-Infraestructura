# =============================================================================
# KEY VAULT MODULE - VARIABLES
# =============================================================================

variable "key_vault_name" {
  description = "Nombre del Key Vault (debe ser único globalmente)"
  type        = string

  validation {
    condition     = length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 24
    error_message = "El nombre del Key Vault debe tener entre 3 y 24 caracteres."
  }
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "sku_name" {
  description = "SKU del Key Vault"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "El SKU debe ser 'standard' o 'premium'."
  }
}

variable "network_acls_default_action" {
  description = "Acción predeterminada para Network ACLs"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.network_acls_default_action)
    error_message = "La acción debe ser 'Allow' o 'Deny'."
  }
}

variable "aks_principal_id" {
  description = "Object ID del Managed Identity de AKS (para acceso a secretos)"
  type        = string
  default     = null
}

variable "secrets" {
  description = "Mapa de secretos a crear en el Key Vault"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags para aplicar al Key Vault"
  type        = map(string)
  default     = {}
}
