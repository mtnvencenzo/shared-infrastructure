module "shared_servicebus_namespace" {
  source = "git::ssh://git@github.com/mtnvencenzo/Terraform-Modules.git//modules/servicebus-namespace"

  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  sub                 = var.sub
  region              = var.region
  environment         = var.environment
  domain              = var.domain

  public_network_access_enabled = true
  local_auth_enabled            = true

  providers = {
    azurerm = azurerm
  }
}

