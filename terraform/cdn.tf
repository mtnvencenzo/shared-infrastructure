resource "azurerm_cdn_profile" "cdn" {
  name                  = "cdn-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name   = data.azurerm_resource_group.global_shared_resource_group.name
  location              = data.azurerm_resource_group.global_shared_resource_group.location
  sku                   = "Standard_Verizon"
  tags                  = local.tags

  lifecycle {
    ignore_changes = [ sku ]
  }
}

resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                  = "afd-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name   = data.azurerm_resource_group.global_shared_resource_group.name
  sku_name              = "Standard_AzureFrontDoor"
  tags                  = local.tags
}