module "ai_search_svc" {
  source = "git::ssh://git@github.com/mtnvencenzo/Terraform-Modules.git//modules/ai-search"
  providers = {
    azurerm = azurerm
  }

  sub         = var.sub
  region      = var.region
  environment = var.environment
  domain      = var.domain
  sequence    = var.sequence

  sku                           = "free"
  replica_count                 = 1
  partition_count               = 1
  public_network_access_enabled = true

  tags = local.tags
}

