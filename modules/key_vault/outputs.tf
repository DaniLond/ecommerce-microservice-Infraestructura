# =============================================================================
# KEY VAULT MODULE - OUTPUTS
# =============================================================================

output "key_vault_id" {
  description = "ID del Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "URI del Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "tenant_id" {
  description = "Tenant ID del Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}
