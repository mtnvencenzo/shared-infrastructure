
module "acr" {
  source = "git::ssh://git@github.com/mtnvencenzo/terraform-modules.git//modules/container-registry"
  providers = {
    azurerm = azurerm
  }

  resource_group_name     = data.azurerm_resource_group.global_shared_resource_group.name
  resource_group_location = data.azurerm_resource_group.global_shared_resource_group.location
  domain                  = var.domain
  environment             = var.environment

  sku                   = "Basic"
  admin_enabled         = true
  data_endpoint_enabled = false
}

# import {
#   to = module.acr.azurerm_container_registry.acr
#   id = "/subscriptions/1d9ecc00-242a-460d-8b08-b71db19f094e/resourceGroups/rg-vec-eus-glo-shared-001/providers/Microsoft.ContainerRegistry/registries/acrveceusgloshared001"
# }