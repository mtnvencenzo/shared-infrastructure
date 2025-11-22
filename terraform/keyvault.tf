module "keyvault" {
  source = "git::ssh://git@github.com/mtnvencenzo/terraform-modules.git//modules/key-vault"
  providers = {
    azurerm = azurerm
  }

  sub                     = var.sub
  region                  = var.region
  environment             = var.environment
  domain                  = var.domain
  shortdomain             = var.shortdomain
  sequence                = var.short_sequence
  tenant_id               = data.azurerm_client_config.current.tenant_id
  pipeline_object_id      = data.azurerm_client_config.current.object_id
  resource_group_name     = data.azurerm_resource_group.global_shared_resource_group.name
  resource_group_location = data.azurerm_resource_group.global_shared_resource_group.location

  virtual_network_subnet_ids = []

  secrets = [
    {
      name  = "otel-collector-api-key-cocktails-api"
      value = random_password.otel_config_api_key_cocktails_api.result
      tags = {
        Application = var.domain
        Environment = var.environment
      }
    },
    {
      name  = "otel-collector-api-key-cocktails-web"
      value = random_password.otel_config_api_key_cocktails_web.result
      tags = {
        Application = var.domain
        Environment = var.environment
      }
    },
    {
      name  = "otel-collector-api-key-cocktails-mcp"
      value = random_password.otel_config_api_key_cocktails_mcp.result
      tags = {
        Application = var.domain
        Environment = var.environment
      }
    },
    {
      name  = "qdrant-api-key"
      value = random_password.qdrant_api_key.result
      tags = {
        Application = var.domain
        Environment = var.environment
      }
    }
  ]
  secrets_values_ignored = [
    {
      name  = "github-terraform-module-repo-public-key"
      value = "n/a"
      tags = {
        Application = var.domain
        Environment = var.environment
      }
    },
    {
      name  = "github-terraform-module-repo-private-key"
      value = "n/a"
      tags = {
        Application     = var.domain
        Environment     = var.environment
        "file-encoding" = "utf-8"
      }
    },
    {
      name  = "github-pat-mtnvencenzo-packages-readwrite"
      value = "n/a"
      tags = {
        Application     = var.domain
        Environment     = var.environment
        "file-encoding" = "utf-8"
      }
    },
    {
      name  = "github-pat-mtnvencenzo-packages-read"
      value = "n/a"
      tags = {
        Application     = var.domain
        Environment     = var.environment
        "file-encoding" = "utf-8"
      }
    }
  ]
}