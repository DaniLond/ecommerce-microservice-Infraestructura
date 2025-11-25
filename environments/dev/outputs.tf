# =============================================================================
# ENVIRONMENT: DEV - OUTPUTS
# =============================================================================

output "resource_group_id" {
  description = "ID del Resource Group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = module.resource_group.resource_group_name
}

output "location" {
  description = "Ubicación de los recursos"
  value       = module.resource_group.location
}

# -----------------------------------------------------------------------------
# AKS OUTPUTS
# -----------------------------------------------------------------------------

output "aks_cluster_id" {
  description = "ID del clúster AKS"
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "Nombre del clúster AKS"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "FQDN del clúster AKS"
  value       = module.aks.cluster_fqdn
}

output "aks_node_resource_group" {
  description = "Resource group de los nodos AKS"
  value       = module.aks.node_resource_group
}

output "aks_identity_principal_id" {
  description = "Principal ID de la identidad del clúster"
  value       = module.aks.identity_principal_id
}

output "kubelet_identity_object_id" {
  description = "Object ID de la identidad de kubelet"
  value       = module.aks.kubelet_identity_object_id
}

# -----------------------------------------------------------------------------
# NETWORKING OUTPUTS
# -----------------------------------------------------------------------------

output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = module.networking.vnet_name
}

output "aks_subnet_id" {
  description = "ID de la subnet de AKS"
  value       = module.networking.aks_subnet_id
}

output "public_ip_address" {
  description = "Dirección IP pública del Ingress (si se creó)"
  value       = module.networking.public_ip_address
}

# -----------------------------------------------------------------------------
# KEY VAULT OUTPUTS
# -----------------------------------------------------------------------------

output "key_vault_id" {
  description = "ID del Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "URI del Key Vault"
  value       = module.key_vault.key_vault_uri
}

# -----------------------------------------------------------------------------
# KUBECTL CONFIGURATION
# -----------------------------------------------------------------------------

output "configure_kubectl_command" {
  description = "Comando para configurar kubectl"
  value       = "az aks get-credentials --resource-group ${module.resource_group.resource_group_name} --name ${module.aks.cluster_name}"
}
