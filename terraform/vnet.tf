resource "azurerm_virtual_network" "global_vnet" {
  name                = "vnet-${var.sub}-${var.region}-${var.environment}-network-${var.sequence}"
  location            = azurerm_resource_group.global_network_resource_group.location
  resource_group_name = azurerm_resource_group.global_network_resource_group.name
  address_space       = ["10.0.0.0/16"]
  tags     = local.tags
  depends_on = [
    azurerm_resource_group.global_network_resource_group
  ]
  lifecycle {
    prevent_destroy = true
  }
} 