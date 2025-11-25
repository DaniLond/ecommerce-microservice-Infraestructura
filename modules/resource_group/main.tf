# =============================================================================
# RESOURCE GROUP MODULE - MAIN
# =============================================================================
# Este módulo crea un Resource Group en Azure
# Un Resource Group es un contenedor lógico para recursos de Azure

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Module    = "resource_group"
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
