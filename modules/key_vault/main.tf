# =============================================================================
# KEY VAULT MODULE - MAIN
# =============================================================================
# Este módulo crea un Azure Key Vault para gestionar secretos, claves y certificados

# Obtener el Tenant ID actual
data "azurerm_client_config" "current" {}

# -----------------------------------------------------------------------------
# KEY VAULT
# -----------------------------------------------------------------------------
resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Habilitar acceso para Azure Services
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  # Network ACLs
  network_acls {
    bypass         = "AzureServices"
    default_action = var.network_acls_default_action
  }

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Module    = "key_vault"
    }
  )
}

# -----------------------------------------------------------------------------
# ACCESS POLICY PARA EL USUARIO/SERVICE PRINCIPAL ACTUAL
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]
}

# -----------------------------------------------------------------------------
# ACCESS POLICY PARA AKS (SI SE PROPORCIONA)
# -----------------------------------------------------------------------------
# Comentado temporalmente debido a dependencias circulares con AKS
# Se puede habilitar después del primer apply con -target
# resource "azurerm_key_vault_access_policy" "aks" {
#   count        = var.aks_principal_id != null ? 1 : 0
#   key_vault_id = azurerm_key_vault.this.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = var.aks_principal_id
#
#   secret_permissions = [
#     "Get",
#     "List"
#   ]
# }


resource "azurerm_key_vault_secret" "secrets" {
  for_each     = nonsensitive(var.secrets)
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [
    azurerm_key_vault_access_policy.terraform
  ]

  tags = var.tags
}
