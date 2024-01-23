resource "azurerm_resource_group" "global_network_resource_group" {
  name     = "rg-${var.sub}-${var.region}-${var.environment}-network-${var.sequence}"
  location = var.location
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}