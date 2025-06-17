module "cezzis_keyvault" {
  source = "git::ssh://git@github.com/mtnvencenzo/terraform-modules.git//modules/key-vault"
  providers = {
    azurerm = azurerm
  }

  sub                     = var.sub
  region                  = var.region
  environment             = var.environment
  domain                  = "cocktails"
  shortdomain             = "cockti"
  sequence                = var.short_sequence
  tenant_id               = data.azurerm_client_config.current.tenant_id
  pipeline_object_id      = data.azurerm_client_config.current.object_id
  resource_group_name     = data.azurerm_resource_group.cocktails_glo_resource_group.name
  resource_group_location = data.azurerm_resource_group.cocktails_glo_resource_group.location

  virtual_network_subnet_ids = [
    azurerm_subnet.container_app_environment_subnet.id
  ]

  secrets                = []
  secrets_values_ignored = [
    {
      name  = "github-terraform-module-repo-public-key"
      value = "n/a"
    },
    {
      name  = "github-terraform-module-repo-private-key"
      value = "n/a"
    }
  ]
}