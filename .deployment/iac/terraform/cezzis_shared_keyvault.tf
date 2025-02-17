module "cezzis_keyvault" {
    source  = "git::https://vecchi@dev.azure.com/vecchi/Latest/_git/Terraform-Modules//modules/key-vault"
    providers = {
        azurerm = azurerm
    }
    
    sub                             = var.sub
    region                          = var.region
    environment                     = var.environment
    domain                          = "cocktails"
    shortdomain                     = "cockti"
    sequence                        = var.short_sequence
    tenant_id                       = data.azurerm_client_config.current.tenant_id
    pipeline_object_id              = data.azurerm_client_config.current.object_id
    resource_group_name             = data.azurerm_resource_group.cocktails_glo_resource_group.name
    resource_group_location         = data.azurerm_resource_group.cocktails_glo_resource_group.location
    
    virtual_network_subnet_ids  = []
    secrets                     = []
    secrets_values_ignored      = []
}