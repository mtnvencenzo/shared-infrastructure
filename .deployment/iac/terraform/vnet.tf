resource "azurerm_virtual_network" "global_vnet" {
  name                = "vnet-${var.sub}-${var.region}-${var.environment}-network-${var.sequence}"
  location            = data.azurerm_resource_group.global_network_resource_group.location
  resource_group_name = data.azurerm_resource_group.global_network_resource_group.name
  address_space       = ["10.0.0.0/8"]
  tags     = local.tags
  
  lifecycle {
    prevent_destroy = true
  }
} 