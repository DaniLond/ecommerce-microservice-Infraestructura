# =============================================================================
# ENVIRONMENT: DEV - MAIN CONFIGURATION
# =============================================================================
# Este archivo orquesta todos los módulos para crear el ambiente de desarrollo

terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateecomm24524"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

# -----------------------------------------------------------------------------
# LOCALS
# -----------------------------------------------------------------------------
locals {
  environment = "dev"
  common_tags = {
    Environment = local.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Repository  = "ecommerce-microservice-Infraestructura"
  }
}

# -----------------------------------------------------------------------------
# RESOURCE GROUP
# -----------------------------------------------------------------------------
module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# NETWORKING
# -----------------------------------------------------------------------------
module "networking" {
  source = "../../modules/networking"

  vnet_name                  = "${var.project_name}-${local.environment}-vnet"
  location                   = var.location
  resource_group_name        = module.resource_group.resource_group_name
  vnet_address_space         = var.vnet_address_space
  aks_subnet_name            = "${var.project_name}-${local.environment}-aks-subnet"
  aks_subnet_address_prefix  = var.aks_subnet_address_prefix
  create_public_ip           = var.create_public_ip
  tags                       = local.common_tags

  depends_on = [module.resource_group]
}

# -----------------------------------------------------------------------------
# KEY VAULT
# -----------------------------------------------------------------------------
module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name                 = "${var.project_name}${local.environment}kv${var.suffix}"
  location                       = var.location
  resource_group_name            = module.resource_group.resource_group_name
  sku_name                       = var.key_vault_sku
  network_acls_default_action    = var.key_vault_network_acls_default_action
  aks_principal_id               = module.aks.identity_principal_id
  secrets                        = var.key_vault_secrets
  tags                           = local.common_tags

  depends_on = [module.resource_group, module.aks]
}

# -----------------------------------------------------------------------------
# AZURE KUBERNETES SERVICE (AKS)
# -----------------------------------------------------------------------------
module "aks" {
  source = "../../modules/aks"

  cluster_name               = "${var.project_name}-${local.environment}-aks"
  location                   = var.location
  resource_group_name        = module.resource_group.resource_group_name
  dns_prefix                 = "${var.project_name}-${local.environment}"
  kubernetes_version         = var.kubernetes_version
  
  # Node Pool Configuration
  default_node_pool_name     = "default"
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  os_disk_size_gb            = var.os_disk_size_gb
  max_pods                   = var.max_pods
  
  # Auto-scaling
  enable_auto_scaling        = var.enable_auto_scaling
  min_count                  = var.min_count
  max_count                  = var.max_count
  
  # Networking
  vnet_subnet_id             = module.networking.aks_subnet_id
  vnet_id                    = module.networking.vnet_id
  network_plugin             = var.network_plugin
  network_policy             = var.network_policy
  service_cidr               = var.service_cidr
  dns_service_ip             = var.dns_service_ip
  
  # Add-ons
  enable_azure_ad_rbac                = var.enable_azure_ad_rbac
  admin_group_object_ids              = var.admin_group_object_ids
  enable_azure_policy                 = var.enable_azure_policy
  enable_oms_agent                    = var.enable_oms_agent
  log_analytics_workspace_id          = var.log_analytics_workspace_id
  enable_key_vault_secrets_provider   = var.enable_key_vault_secrets_provider
  
  # ACR Integration (si existe)
  acr_id                     = var.acr_id
  
  # Additional Node Pools
  additional_node_pools      = var.additional_node_pools
  
  tags                       = local.common_tags

  depends_on = [module.resource_group, module.networking]
}
