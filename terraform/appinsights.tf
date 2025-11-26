# resource "azurerm_log_analytics_workspace" "law" {
#   name                = "law-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
#   resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
#   location            = data.azurerm_resource_group.global_shared_resource_group.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   tags                = local.tags

#   daily_quota_gb                          = 0.075
#   immediate_data_purge_on_30_days_enabled = true
# }


# resource "azurerm_log_analytics_workspace_table" "law_tables" {
#   for_each                = toset(var.log_analytics_workspace_tables_for_reduced_retention_period)
#   workspace_id            = azurerm_log_analytics_workspace.law.id
#   name                    = each.value
#   retention_in_days       = var.log_analytics_workspace_tables_reduced_retention_period
#   total_retention_in_days = var.log_analytics_workspace_tables_reduced_retention_period
# }

# resource "azurerm_application_insights" "appi" {
#   name                = "appi-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
#   resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
#   location            = data.azurerm_resource_group.global_shared_resource_group.location
#   workspace_id        = azurerm_log_analytics_workspace.law.id
#   application_type    = "web"
#   tags                = local.tags

#   depends_on = [
#     azurerm_log_analytics_workspace.law
#   ]
# }