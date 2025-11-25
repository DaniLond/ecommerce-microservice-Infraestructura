# =============================================================================
# NETWORKING MODULE - OUTPUTS
# =============================================================================

output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "aks_subnet_id" {
  description = "ID de la subnet de AKS"
  value       = azurerm_subnet.aks.id
}

output "aks_subnet_name" {
  description = "Nombre de la subnet de AKS"
  value       = azurerm_subnet.aks.name
}

output "nsg_id" {
  description = "ID del Network Security Group"
  value       = azurerm_network_security_group.aks.id
}

output "public_ip_address" {
  description = "Dirección IP pública del Ingress (si se creó)"
  value       = var.create_public_ip ? azurerm_public_ip.ingress[0].ip_address : null
}

output "public_ip_id" {
  description = "ID de la IP pública del Ingress (si se creó)"
  value       = var.create_public_ip ? azurerm_public_ip.ingress[0].id : null
}
