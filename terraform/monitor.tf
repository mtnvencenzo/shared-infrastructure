resource "azurerm_monitor_action_group" "team_vecchi_action_group" {
  name                = "ag-teamvecchi-${var.sub}-${var.region}-${var.environment}-${var.domain}"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  short_name          = "teamvec"

  email_receiver {
    name          = "Ron Vecchi"
    email_address = "rvecchi+azure@gmail.com"
  }
}