data "azurerm_resource_group" "global_shared_resource_group" {
  name = "rg-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
}

data "azurerm_resource_group" "global_network_resource_group" {
  name = "rg-${var.sub}-${var.region}-${var.environment}-network-${var.sequence}"
}

data "azurerm_resource_group" "cocktails_glo_resource_group" {
  name = "rg-${var.sub}-${var.region}-glo-cocktails-${var.sequence}"
}

data "azurerm_client_config" "current" {}