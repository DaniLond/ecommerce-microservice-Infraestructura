# =============================================================================
# AKS MODULE - OUTPUTS
# =============================================================================

output "cluster_id" {
  description = "ID del clúster AKS"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Nombre del clúster AKS"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "FQDN del clúster AKS"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "kube_config_raw" {
  description = "Configuración de kubectl en formato raw"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_config" {
  description = "Configuración de kubectl"
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}

output "client_certificate" {
  description = "Certificado de cliente para autenticación"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Llave privada del cliente"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Certificado CA del clúster"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "host" {
  description = "Host del API server de Kubernetes"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
  sensitive   = true
}

output "username" {
  description = "Usuario para autenticación básica"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].username
  sensitive   = true
}

output "password" {
  description = "Password para autenticación básica"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].password
  sensitive   = true
}

output "node_resource_group" {
  description = "Resource group de los nodos (auto-generado por AKS)"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "kubelet_identity_object_id" {
  description = "Object ID de la identidad de kubelet"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "kubelet_identity_client_id" {
  description = "Client ID de la identidad de kubelet"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
}

output "identity_principal_id" {
  description = "Principal ID de la identidad del clúster"
  value       = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "Tenant ID de la identidad del clúster"
  value       = azurerm_kubernetes_cluster.this.identity[0].tenant_id
}

output "oidc_issuer_url" {
  description = "URL del OIDC Issuer"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "key_vault_secrets_provider" {
  description = "Configuración del Key Vault Secrets Provider"
  value = var.enable_key_vault_secrets_provider ? {
    secret_identity_client_id = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].client_id
    secret_identity_object_id = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].object_id
  } : null
}
