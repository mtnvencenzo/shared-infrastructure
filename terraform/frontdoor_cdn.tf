resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                  = "afd-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name   = data.azurerm_resource_group.global_shared_resource_group.name
  sku_name              = "Standard_AzureFrontDoor"
  tags                  = local.tags

  lifecycle {
      prevent_destroy = true
  }
}