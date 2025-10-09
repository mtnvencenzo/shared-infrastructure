# resource "azurerm_container_registry" "acr" {
#   name                  = "acr${var.sub}${var.region}${var.environment}${var.domain}${var.sequence}"
#   resource_group_name   = data.azurerm_resource_group.global_shared_resource_group.name
#   location              = data.azurerm_resource_group.global_shared_resource_group.location
#   sku                   = "Basic"
#   admin_enabled         = true
#   data_endpoint_enabled = false
#   identity {
#     type = "SystemAssigned"
#   }
#   tags = {
#     Environment = "${var.environment}"
#     Application = "${var.domain}"
#   }
#   lifecycle {
#     prevent_destroy = true
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# module "acr" {
#   source = "git::ssh://git@github.com/mtnvencenzo/terraform-modules.git//modules/container-registry"
#   providers = {
#     azurerm = azurerm
#   }
# }

# import {
#     to = module.acr
#     id = "/subscriptions/1d9ecc00-242a-460d-8b08-b71db19f094e/resourceGroups/rg-vec-eus-glo-shared-001/providers/Microsoft.ContainerRegistry/registries/acrveceusgloshared001"
# }