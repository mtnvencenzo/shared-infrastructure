module "shared_cosmosdb_account" {
  source              = "git::ssh://git@github.com/mtnvencenzo/Terraform-Modules.git//modules/cosmos-db-account"
  resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
  location            = data.azurerm_resource_group.global_shared_resource_group.location
  geo_location        = data.azurerm_resource_group.global_shared_resource_group.location
  subnet_ids          = [azurerm_subnet.container_app_environment_subnet.id]

  tags = local.tags

  sub                     = var.sub
  region                  = var.region
  environment             = var.environment
  domain                  = var.domain
  sequence                = var.sequence
  consistency_level       = "Eventual"
  max_interval_in_seconds = 5
  max_staleness_prefix    = 100
  enable_monitor_alerts   = false
  action_group_id         = ""

  # Enabling access from azure data centers (all of them)
  # Needed current because using the free tier of ai search service
  # TODO: remove this when not using the free tier
  ip_range_filter = [
    "0.0.0.0"
  ]

  custom_reader_role_assignments = [
    {
      name         = "3335b819-a0b0-4c0d-a180-79ec100f8930" # must be a uuid
      principal_id = module.ai_search_svc.search_service_identity[0].principal_id
    }
  ]

  cosmos_db_account_reader_role_assignments = [
    {
      principal_id = module.ai_search_svc.search_service_identity[0].principal_id
    }
  ]

  providers = {
    azurerm = azurerm
  }
}

module "shared_cosmosdb_database" {
  source = "git::ssh://git@github.com/mtnvencenzo/Terraform-Modules.git//modules/cosmos-db-sql-db"

  database_name         = var.shared_cosmosdb_database_name
  resource_group_name   = data.azurerm_resource_group.global_shared_resource_group.name
  cosmosdb_account_name = module.shared_cosmosdb_account.cosmosdb_account_name
  database_throughput   = 400

  depends_on = [module.shared_cosmosdb_account]
}