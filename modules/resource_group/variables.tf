# =============================================================================
# RESOURCE GROUP MODULE - VARIABLES
# =============================================================================

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90
    error_message = "El nombre del Resource Group debe tener entre 1 y 90 caracteres."
  }
}

variable "location" {
  description = "Región de Azure donde se creará el Resource Group"
  type        = string
  default     = "East US"

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US",
      "West Europe", "North Europe",
      "Southeast Asia", "East Asia",
      "Brazil South", "Canada Central", "Australia East"
    ], var.location)
    error_message = "La ubicación debe ser una región válida de Azure."
  }
}

variable "tags" {
  description = "Tags para aplicar a todos los recursos"
  type        = map(string)
  default     = {}
}
