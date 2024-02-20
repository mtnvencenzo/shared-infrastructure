

resource "azurerm_api_management" "apim" {
  name                = "apim-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  publisher_name      = "Vecchi"
  publisher_email     = "rvecchi@gmail.com"
  sku_name = "Consumption_0"
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_api_management_logger" "apim_appinsights_logger" {
  name                = "shared-appinsights-logger"
  description         = "Shared app insights logger for the entire api management instance"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  resource_id         = azurerm_application_insights.appi.id

  application_insights {
    instrumentation_key = azurerm_application_insights.appi.instrumentation_key
  }
}