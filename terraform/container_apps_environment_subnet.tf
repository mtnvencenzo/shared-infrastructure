# resource "azurerm_subnet" "container_app_environment_subnet" {
#   name                              = "snet-${var.sub}-${var.region}-${var.environment}-${var.domain}containers-${var.sequence}"
#   resource_group_name               = azurerm_virtual_network.global_vnet.resource_group_name
#   virtual_network_name              = azurerm_virtual_network.global_vnet.name
#   address_prefixes                  = var.containers_subnet_address_prefixes
#   private_endpoint_network_policies = "Enabled"

#   service_endpoints = [
#     "Microsoft.KeyVault",
#     "Microsoft.AzureCosmosDB",
#     "Microsoft.ServiceBus",
#     "Microsoft.Storage"
#   ]

#   delegation {
#     name = "${var.environment}-${var.domain}-containers-delegation"

#     service_delegation {
#       name    = "Microsoft.App/environments"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
#     }
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }