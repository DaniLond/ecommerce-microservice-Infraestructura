# =============================================================================
# RESOURCE GROUP MODULE - OUTPUTS
# =============================================================================

output "resource_group_id" {
  description = "ID del Resource Group creado"
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Nombre del Resource Group creado"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Ubicación del Resource Group"
  value       = azurerm_resource_group.this.location
}
