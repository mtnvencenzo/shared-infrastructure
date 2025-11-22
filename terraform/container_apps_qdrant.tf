resource "random_password" "qdrant_api_key" {
  length  = 24
  special = true
  upper   = true
}


# File share
resource "azurerm_storage_share" "qdrant_storage" {
  name                 = "share-qdrant-storage"
  quota                = 1
  storage_account_name = azurerm_storage_account.storage.name
}


resource "azurerm_storage_share_directory" "qdrant_storage" {
  name             = "qdrant-data"
  storage_share_id = azurerm_storage_share.qdrant_storage.id
}

# Environment-level storage configuration for QDRANT storage
resource "azurerm_container_app_environment_storage" "qdrant_storage" {
  name                         = "st-qdrant-storage"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  access_mode                  = "ReadWrite"
  account_name                 = azurerm_storage_account.storage.name
  share_name                   = azurerm_storage_share.qdrant_storage.name
  access_key                   = azurerm_storage_account.storage.primary_access_key
}

# Container App for QDrant Vector Database
resource "azurerm_container_app" "qdrant" {
  name                         = "aca-${var.sub}-${var.region}-${var.environment}-qdrant-${var.sequence}"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = data.azurerm_resource_group.global_shared_resource_group.name
  revision_mode                = "Single"
  tags                         = local.tags
  max_inactive_revisions       = 5
  workload_profile_name        = "Consumption"

  template {
    container {
      name   = "qdrant"
      image  = "qdrant/qdrant:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "QDRANT__LOG_LEVEL"
        value = "INFO"
      }

      env {
        name  = "QDRANT__SERVICE__API_KEY"
        value = random_password.qdrant_api_key.result
      }

      volume_mounts {
        name = "qdrant"
        path = "/qdrant/storage"
      }
    }

    volume {
      name         = "qdrant"
      storage_name = azurerm_container_app_environment_storage.qdrant_storage.name
      storage_type = "AzureFile"
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = 6333
    exposed_port     = 6333
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_storage_share_directory.qdrant_storage,
    azurerm_container_app_environment_storage.qdrant_storage
  ]
}