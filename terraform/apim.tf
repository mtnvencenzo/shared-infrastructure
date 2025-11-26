

# resource "azurerm_api_management" "apim" {
#   name                = "apim-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
#   resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
#   location            = data.azurerm_resource_group.global_shared_resource_group.location
#   publisher_name      = "Vecchi"
#   publisher_email     = "rvecchi@gmail.com"
#   sku_name            = "Consumption_0"
#   tags                = local.tags

#   identity {
#     type = "SystemAssigned"
#   }
# }
