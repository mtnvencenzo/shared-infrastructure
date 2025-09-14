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
    default_action = "Allow"
    bypass         = ["AzureServices"]
    # ip_rules       = []
    # virtual_network_subnet_ids = [
    #   azurerm_subnet.container_app_environment_subnet.id
    # ]
  }
}

# ----------------------------------------
# OTEL Collector Telmetry Api Key
# ----------------------------------------
resource "random_password" "otel_config_api_key_cocktails_api" {
  length  = 24
  special = true
  upper   = true
}

resource "random_password" "otel_config_api_key_cocktails_web" {
  length  = 24
  special = true
  upper   = true
}

resource "random_password" "otel_config_api_key_cocktails_mcp" {
  length  = 24
  special = true
  upper   = true
}

# File share for OTEL config
resource "azurerm_storage_share" "otel_config" {
  name                 = "share-otel-collector-config"
  quota                = 1
  storage_account_name = azurerm_storage_account.otel.name
}

# OTEL config file
resource "local_sensitive_file" "otel_config" {
  filename = "${path.module}/otel-collector-config.yml"
  depends_on = [
    random_password.otel_config_api_key_cocktails_api,
    random_password.otel_config_api_key_cocktails_web,
    random_password.otel_config_api_key_cocktails_mcp
  ]
  content = <<-EOT
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: "0.0.0.0:4317"
            auth:
              authenticator: bearertokenauth/server
          http:
            endpoint: "0.0.0.0:4318"
            auth:
              authenticator: bearertokenauth/server
            cors:
              allowed_origins: ["https://www.cezzis.com", "https://cezzis.com"]
              allowed_headers: ["*"]
              max_age: 600

    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024

    exporters:
      azuremonitor:

    extensions:
      bearertokenauth/server:
        tokens:
          - "${random_password.otel_config_api_key_cocktails_api.result}"
          - "${random_password.otel_config_api_key_cocktails_web.result}"
          - "${random_password.otel_config_api_key_cocktails_mcp.result}"

    service:
      extensions: [bearertokenauth/server]
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
  source           = local_sensitive_file.otel_config.filename
  content_type     = "application/x-yaml"
  content_md5      = filemd5(local_sensitive_file.otel_config.filename)
}

# Environment-level storage configuration for OTEL config
resource "azurerm_container_app_environment_storage" "otel_config" {
  name                         = "st-otel-config"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  access_mode                  = "ReadOnly"
  account_name                 = azurerm_storage_account.otel.name
  share_name                   = azurerm_storage_share.otel_config.name
  access_key                   = azurerm_storage_account.otel.primary_access_key
}

# Container App for OTEL collector
resource "azurerm_container_app" "otel_collector" {
  name                         = "aca-${var.sub}-${var.region}-${var.environment}-otelcol-${var.sequence}"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = data.azurerm_resource_group.global_shared_resource_group.name
  revision_mode                = "Single"
  tags                         = local.tags
  max_inactive_revisions       = 5
  workload_profile_name        = "Consumption"

  template {
    container {
      name   = "otel-collector"
      image  = "otel/opentelemetry-collector-contrib:0.135.0"
      cpu    = 0.25
      memory = "0.5Gi"

      command = [
        "/otelcol-contrib",
        "--config=/mnt/otel/otel-collector-config.yml"
      ]

      env {
        name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        value = azurerm_application_insights.appi.connection_string
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
    azurerm_storage_share_file.otel_config_upload,
    azurerm_container_app_environment_storage.otel_config
  ]
}