resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_application_insights" "appi" {
  name                = "appi-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags     = local.tags
  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
  lifecycle {
    prevent_destroy = true
  }
}