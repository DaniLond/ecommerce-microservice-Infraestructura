# =============================================================================
# NETWORKING MODULE - MAIN
# =============================================================================
# Este módulo crea los recursos de red para el clúster AKS

# -----------------------------------------------------------------------------
# VIRTUAL NETWORK
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Module    = "networking"
    }
  )
}

# -----------------------------------------------------------------------------
# SUBNET PARA AKS
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.aks_subnet_address_prefix

  # Delegar la subnet a AKS
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry",
    "Microsoft.Sql"
  ]
}

# -----------------------------------------------------------------------------
# NETWORK SECURITY GROUP PARA AKS
# -----------------------------------------------------------------------------
resource "azurerm_network_security_group" "aks" {
  name                = "${var.aks_subnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Module    = "networking"
      Purpose   = "AKS"
    }
  )
}

# Regla para permitir tráfico HTTPS desde internet
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks.name
}

# Regla para permitir tráfico HTTP desde internet
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "AllowHTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks.name
}

# -----------------------------------------------------------------------------
# ASOCIAR NSG CON SUBNET
# -----------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

# -----------------------------------------------------------------------------
# PUBLIC IP PARA INGRESS (OPCIONAL)
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "ingress" {
  count               = var.create_public_ip ? 1 : 0
  name                = "${var.vnet_name}-ingress-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Module    = "networking"
      Purpose   = "Ingress"
    }
  )
}
