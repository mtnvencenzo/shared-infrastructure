
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