# Storage account for OTEL config
resource "azurerm_storage_account" "otel" {
  name                          = "st${var.sub}${var.region}${var.environment}${var.domain}${var.sequence}"
  resource_group_name           = data.azurerm_resource_group.global_shared_resource_group.name
  location                      = data.azurerm_resource_group.global_shared_resource_group.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  https_traffic_only_enabled    = true
  access_tier                   = "Hot"
  min_tls_version               = "TLS1_2"
  tags                          = local.tags
  public_network_access_enabled = true

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
  name                 = "share-otel-collector-config"
  quota                = 1
  storage_account_name = azurerm_storage_account.otel.name
}

# OTEL config file
resource "local_file" "otel_config" {
  filename = "${path.module}/otel-collector-config.yml"
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
  name             = "otel-collector-config.yml"
  storage_share_id = azurerm_storage_share.otel_config.id
  source           = local_file.otel_config.filename
  content_type     = "application/x-yaml"
}

# Managed identity for the OTEL collector
resource "azurerm_user_assigned_identity" "aca_otel_collector_identity" {
  name                = "mi-${var.sub}-${var.region}-${var.environment}-${var.domain}otelcollector-${var.sequence}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  tags                = local.tags
}

# Role assignment for storage access
resource "azurerm_role_assignment" "otel_collector_storage" {
  scope                = azurerm_storage_account.otel.id
  role_definition_name = "Storage File Data SMB Share Reader"
  principal_id         = azurerm_user_assigned_identity.aca_otel_collector_identity.principal_id
}


resource "azurerm_container_app_environment_storage" "otel_config" {
  name                         = "acast-otel-config"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  access_mode                  = "ReadOnly"
  account_name                 = azurerm_storage_account.otel.name
  account_key                  = azurerm_storage_account.otel.primary_access_key
  share_name                   = azurerm_storage_share.otel_config.name
}


# Container App for OTEL collector
resource "azurerm_container_app" "otel_collector" {
  name                         = "ca-otel-collector-${var.sub}-${var.environment}-${var.sequence}"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = data.azurerm_resource_group.global_shared_resource_group.name
  revision_mode                = "Single"
  tags                         = local.tags
  max_inactive_revisions       = 5
  workload_profile_name        = "Consumption"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_otel_collector_identity.id]
  }

  template {
    container {
      name   = "otel-collector"
      image  = "otel/opentelemetry-collector-contrib:0.135.0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "CONFIG_FILE"
        value = "/mnt/otel/otel-collector-config.yml"
      }

      volume_mounts {
        name = "otel-config"
        path = "/mnt/otel"
      }
    }

    volume {
      name         = "otel-config"
      storage_name = azurerm_container_app_environment_storage.otel_config.name
      storage_type = "AzureFile"
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 4317
    transport        = "http2"

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