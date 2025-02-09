resource "azurerm_dns_zone" "cezzis_dns_zone" {
  name                            = "cezzis.com"
  resource_group_name             = data.azurerm_resource_group.cocktails_glo_resource_group.name
}

import {
  to = azurerm_dns_zone.cezzis_dns_zone
  id = "/subscriptions/1d9ecc00-242a-460d-8b08-b71db19f094e/resourceGroups/rg-vec-eus-glo-cocktails-001/providers/Microsoft.Network/dnsZones/cezzis.com"
}
