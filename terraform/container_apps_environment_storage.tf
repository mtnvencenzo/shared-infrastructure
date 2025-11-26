resource "azurerm_storage_account" "storage" {
  name                          = "st${var.sub}${var.region}${var.environment}${var.domain}${var.sequence}"
  resource_group_name           = data.azurerm_resource_group.global_shared_resource_group.name
  location                      = data.azurerm_resource_group.global_shared_resource_group.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  https_traffic_only_enabled    = true
  access_tier                   = "Hot"
  min_tls_version               = "TLS1_2"
  tags                          = local.tags
  public_network_access_enabled = true

  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    # ip_rules       = []
    # virtual_network_subnet_ids = [
    #   azurerm_subnet.container_app_environment_subnet.id
    # ]
  }
}