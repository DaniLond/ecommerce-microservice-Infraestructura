# =============================================================================
# AKS MODULE - VARIABLES
# =============================================================================

# -----------------------------------------------------------------------------
# REQUIRED VARIABLES
# -----------------------------------------------------------------------------

variable "cluster_name" {
  description = "Nombre del clúster AKS"
  type        = string

  validation {
    condition     = length(var.cluster_name) >= 1 && length(var.cluster_name) <= 63
    error_message = "El nombre del clúster debe tener entre 1 y 63 caracteres."
  }
}

variable "location" {
  description = "Región de Azure donde se desplegará el clúster"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "dns_prefix" {
  description = "Prefijo DNS para el clúster AKS"
  type        = string
}

variable "vnet_subnet_id" {
  description = "ID de la subnet donde se desplegarán los nodos"
  type        = string
}

variable "vnet_id" {
  description = "ID de la Virtual Network para asignar permisos"
  type        = string
}

# -----------------------------------------------------------------------------
# KUBERNETES VERSION
# -----------------------------------------------------------------------------

variable "kubernetes_version" {
  description = "Versión de Kubernetes a usar"
  type        = string
  default     = "1.33.5"
}

# -----------------------------------------------------------------------------
# NODE POOL CONFIGURATION
# -----------------------------------------------------------------------------

variable "default_node_pool_name" {
  description = "Nombre del node pool por defecto"
  type        = string
  default     = "default"

  validation {
    condition     = length(var.default_node_pool_name) <= 12
    error_message = "El nombre del node pool debe tener máximo 12 caracteres."
  }
}

variable "node_count" {
  description = "Número de nodos en el node pool por defecto"
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 100
    error_message = "El número de nodos debe estar entre 1 y 100."
  }
}

variable "vm_size" {
  description = "Tamaño de las VMs para los nodos"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  description = "Tamaño del disco del sistema operativo en GB"
  type        = number
  default     = 128

  validation {
    condition     = var.os_disk_size_gb >= 30 && var.os_disk_size_gb <= 2048
    error_message = "El tamaño del disco debe estar entre 30 y 2048 GB."
  }
}

variable "max_pods" {
  description = "Número máximo de pods por nodo"
  type        = number
  default     = 110
}

# -----------------------------------------------------------------------------
# AUTO-SCALING
# -----------------------------------------------------------------------------

variable "enable_auto_scaling" {
  description = "Habilitar auto-escalado del node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Número mínimo de nodos (cuando auto-scaling está habilitado)"
  type        = number
  default     = 3
}

variable "max_count" {
  description = "Número máximo de nodos (cuando auto-scaling está habilitado)"
  type        = number
  default     = 10
}

# -----------------------------------------------------------------------------
# NETWORKING
# -----------------------------------------------------------------------------

variable "network_plugin" {
  description = "Plugin de red de Kubernetes"
  type        = string
  default     = "azure"

  validation {
    condition     = contains(["azure", "kubenet"], var.network_plugin)
    error_message = "El plugin debe ser 'azure' o 'kubenet'."
  }
}

variable "network_policy" {
  description = "Política de red para el clúster"
  type        = string
  default     = "azure"

  validation {
    condition     = contains(["azure", "calico", ""], var.network_policy)
    error_message = "La política de red debe ser 'azure', 'calico' o vacía."
  }
}

variable "service_cidr" {
  description = "CIDR para servicios de Kubernetes"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP para el servicio DNS de Kubernetes"
  type        = string
  default     = "10.1.0.10"
}

# -----------------------------------------------------------------------------
# AZURE AD RBAC
# -----------------------------------------------------------------------------

variable "enable_azure_ad_rbac" {
  description = "Habilitar integración con Azure AD para RBAC"
  type        = bool
  default     = false
}

variable "admin_group_object_ids" {
  description = "IDs de grupos de Azure AD con permisos de administrador"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# ADD-ONS
# -----------------------------------------------------------------------------

variable "enable_azure_policy" {
  description = "Habilitar Azure Policy add-on"
  type        = bool
  default     = false
}

variable "enable_oms_agent" {
  description = "Habilitar OMS Agent para Azure Monitor"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "ID del workspace de Log Analytics"
  type        = string
  default     = null
}

variable "enable_key_vault_secrets_provider" {
  description = "Habilitar Key Vault Secrets Provider"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# MAINTENANCE WINDOW
# -----------------------------------------------------------------------------

variable "maintenance_window" {
  description = "Ventana de mantenimiento para el clúster"
  type = object({
    day   = string
    hours = list(number)
  })
  default = null
}

# -----------------------------------------------------------------------------
# AZURE CONTAINER REGISTRY
# -----------------------------------------------------------------------------

variable "acr_id" {
  description = "ID del Azure Container Registry para integración con AKS"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# ADDITIONAL NODE POOLS
# -----------------------------------------------------------------------------

variable "additional_node_pools" {
  description = "Configuración de node pools adicionales"
  type = map(object({
    name                = string
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    max_pods            = number
    os_disk_size_gb     = number
    os_type             = string
    node_labels         = map(string)
    node_taints         = list(string)
    tags                = map(string)
  }))
  default = {}
}

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------

variable "tags" {
  description = "Tags para aplicar a los recursos de AKS"
  type        = map(string)
  default     = {}
}
