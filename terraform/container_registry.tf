

resource "azurerm_container_registry" "acr" {  
  name                = "acr${var.sub}${var.region}${var.environment}${var.domain}${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  sku                 = "Basic"
  admin_enabled       = true
  data_endpoint_enabled = false
  identity {
    type = "SystemAssigned"
  }
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags
    ]
  }
}
