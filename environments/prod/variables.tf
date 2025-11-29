# Copia de variables para producción
# Modifica los valores por los de tu entorno prod si es necesario

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "ecommerce"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "ecommerce-prod-rg2"
}

variable "suffix" {
  description = "Sufijo para recursos que requieren nombres únicos globalmente"
  type        = string
  default     = "prod001"
}

variable "vnet_address_space" {
  description = "Rango de direcciones CIDR para la VNet"
  type        = list(string)
  default     = ["10.10.0.0/23"]
}

variable "aks_subnet_address_prefix" {
  description = "Rango de direcciones CIDR para la subnet de AKS"
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "create_public_ip" {
  description = "Crear una IP pública para el Ingress Controller"
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes"
  type        = string
  default     = "1.33.5"
}

variable "node_count" {
  description = "Número de nodos en el node pool por defecto"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Tamaño de las VMs para los nodos"
  type        = string
  default     = "Standard_B2s"
}

variable "os_disk_size_gb" {
  description = "Tamaño del disco del sistema operativo en GB"
  type        = number
  default     = 128
}

variable "max_pods" {
  description = "Número máximo de pods por nodo"
  type        = number
  default     = 110
}

variable "enable_auto_scaling" {
  description = "Habilitar auto-escalado del node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Número mínimo de nodos (cuando auto-scaling está habilitado)"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Número máximo de nodos (cuando auto-scaling está habilitado)"
  type        = number
  default     = 1
}

variable "network_plugin" {
  description = "Plugin de red de Kubernetes"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Política de red para el clúster"
  type        = string
  default     = "azure"
}

variable "service_cidr" {
  description = "CIDR para servicios de Kubernetes"
  type        = string
  default     = "10.11.0.0/16"
}

variable "dns_service_ip" {
  description = "IP para el servicio DNS de Kubernetes"
  type        = string
  default     = "10.11.0.10"
}

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

variable "acr_id" {
  description = "ID del Azure Container Registry para integración con AKS"
  type        = string
  default     = null
}

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

variable "key_vault_sku" {
  description = "SKU del Key Vault"
  type        = string
  default     = "standard"
}

variable "key_vault_network_acls_default_action" {
  description = "Acción predeterminada para Network ACLs del Key Vault"
  type        = string
  default     = "Allow"
}

variable "key_vault_secrets" {
  description = "Mapa de secretos a crear en el Key Vault"
  type        = map(string)
  default     = {}
  sensitive   = true
}
