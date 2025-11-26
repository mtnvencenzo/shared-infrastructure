# resource "azurerm_container_app_environment" "container_app_environment" {
#   name                           = "cae-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
#   resource_group_name            = data.azurerm_resource_group.global_shared_resource_group.name
#   location                       = data.azurerm_resource_group.global_shared_resource_group.location
#   internal_load_balancer_enabled = false
#   tags                           = local.tags


#   infrastructure_resource_group_name          = "rg-cae-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
#   infrastructure_subnet_id                    = azurerm_subnet.container_app_environment_subnet.id
#   log_analytics_workspace_id                  = azurerm_log_analytics_workspace.law.id
#   dapr_application_insights_connection_string = azurerm_application_insights.appi.connection_string

#   workload_profile {
#     name                  = "Consumption"
#     workload_profile_type = "Consumption"
#     maximum_count         = 0
#     minimum_count         = 0
#   }
# }