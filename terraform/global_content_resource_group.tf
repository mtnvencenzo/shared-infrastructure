resource "azurerm_resource_group" "global_content_resource_group" {
  name     = "rg-${var.sub}-${var.region}-${var.environment}-content-${var.sequence}"
  location = var.location
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "global_content_storage_account" {
  name								= "st${var.sub}${var.environment}content${var.sequence}"
  resource_group_name				= azurerm_resource_group.global_content_resource_group.name
  location							= azurerm_resource_group.global_content_resource_group.location
  account_tier						= "Standard"
  account_replication_type			= "LRS"
  cross_tenant_replication_enabled	= false
  access_tier						= "Hot"
  enable_https_traffic_only			= true
  min_tls_version					= "TLS1_2"
  shared_access_key_enabled			= true
  public_network_access_enabled		= true
  tags						= local.tags
  depends_on = [
    azurerm_resource_group.global_content_resource_group
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "global_content_storage_container" {
  name                  = "public"
  storage_account_name  = azurerm_storage_account.global_content_storage_account.name
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.global_content_storage_account
  ]
  lifecycle {
    prevent_destroy = true
  }
}