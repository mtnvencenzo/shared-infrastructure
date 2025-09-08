resource "azurerm_container_app_environment" "container_app_environment" {
  name                           = "cae-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  resource_group_name            = data.azurerm_resource_group.global_shared_resource_group.name
  location                       = data.azurerm_resource_group.global_shared_resource_group.location
  internal_load_balancer_enabled = false
  tags                           = local.tags


  infrastructure_resource_group_name          = "rg-cae-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
  infrastructure_subnet_id                    = azurerm_subnet.container_app_environment_subnet.id
  log_analytics_workspace_id                  = azurerm_log_analytics_workspace.law.id
  dapr_application_insights_connection_string = azurerm_application_insights.appi.connection_string

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    maximum_count         = 0
    minimum_count         = 0
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azapi_update_resource" "cae_app_insights_open_telemetry_integration" {
  name      = azurerm_container_app_environment.container_app_environment.name
  parent_id = data.azurerm_resource_group.global_shared_resource_group.id
  type      = "Microsoft.App/managedEnvironments@2023-11-02-preview"
  body = {
    properties = {
      appInsightsConfiguration = {
        connectionString = azurerm_application_insights.appi.connection_string
      }
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.law.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
        }
      }
      openTelemetryConfiguration = {
        tracesConfiguration = {
          destinations = ["appInsights"]
        }
        logsConfiguration = {
          destinations = ["appInsights"]
        }
      }
    }
  }
}