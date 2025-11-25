# =============================================================================
# NETWORKING MODULE - VARIABLES
# =============================================================================

variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "vnet_address_space" {
  description = "Rango de direcciones CIDR para la VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Nombre de la subnet para AKS"
  type        = string
  default     = "aks-subnet"
}

variable "aks_subnet_address_prefix" {
  description = "Rango de direcciones CIDR para la subnet de AKS"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "create_public_ip" {
  description = "Crear una IP pública para el Ingress Controller"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para aplicar a los recursos de red"
  type        = map(string)
  default     = {}
}
