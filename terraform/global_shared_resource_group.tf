resource "azurerm_resource_group" "global_shared_resource_group" {
  name     = "rg-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  location = var.location
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}