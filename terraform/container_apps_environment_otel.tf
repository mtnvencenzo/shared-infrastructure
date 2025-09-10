# Storage account for OTEL config
resource "azurerm_storage_account" "otel" {
  name                     = "stotel${var.sub}${var.environment}${var.sequence}"
  resource_group_name      = data.azurerm_resource_group.global_shared_resource_group.name
  location                 = data.azurerm_resource_group.global_shared_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = []
    virtual_network_subnet_ids = [
      azurerm_subnet.container_app_environment_subnet.id
    ]
  }
}

# File share for OTEL config
resource "azurerm_storage_share" "otel_config" {
  name                 = "otel-config"
  quota                = 1
  storage_account_name = azurerm_storage_account.otel.name
}

# OTEL config file
resource "local_file" "otel_config" {
  filename = "${path.module}/otel-config.yaml"
  content  = <<-EOT
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: "0.0.0.0:4317"
          http:
            endpoint: "0.0.0.0:4318"

    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024

    exporters:
      azuremonitor:
        instrumentation_key: "${azurerm_application_insights.appi.instrumentation_key}"

    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor]
        logs:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor]
  EOT
}

resource "azurerm_storage_share_file" "otel_config_upload" {
  name             = "config.yaml"
  storage_share_id = azurerm_storage_share.otel_config.id
  source           = local_file.otel_config.filename
  content_type     = "application/x-yaml"
  content_md5      = filemd5(local_file.otel_config.filename)
}

# Managed identity for the OTEL collector
resource "azurerm_user_assigned_identity" "otel_collector" {
  name                = "id-otel-collector-${var.sub}-${var.environment}-${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  tags                = local.tags
}

# Role assignment for storage access
resource "azurerm_role_assignment" "otel_collector_storage" {
  scope                = azurerm_storage_account.otel.id
  role_definition_name = "Storage File Data SMB Share Reader"
  principal_id         = azurerm_user_assigned_identity.otel_collector.principal_id
}

# Container App for OTEL collector
resource "azurerm_container_app" "otel_collector" {
  name                         = "ca-otel-collector-${var.sub}-${var.environment}-${var.sequence}"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name         = data.azurerm_resource_group.global_shared_resource_group.name
  revision_mode               = "Single"
  tags                        = local.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.otel_collector.id]
  }

  template {
    container {
      name   = "otel-collector"
      image  = "otel/opentelemetry-collector-contrib:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "CONFIG_FILE"
        value = "/etc/otel/config.yaml"
      }

      volume_mounts {
        name = "otel-config"
        path = "/etc/otel"
      }
    }

    volume {
      name         = "otel-config"
      storage_name = azurerm_storage_share.otel_config.name
      storage_type = "AzureFile"
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port     = 4317
    transport       = "http2"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_role_assignment.otel_collector_storage,
    azurerm_storage_share_file.otel_config_upload
  ]
}