module "shared_communication_service" {
    source = "git::https://vecchi@dev.azure.com/vecchi/Latest/_git/Terraform-Modules//modules/communication-service"
    sub                     = var.sub
    region                  = var.region
    environment             = var.environment
    domain                  = var.domain
    sequence                = var.sequence
    resource_group_name     = data.azurerm_resource_group.global_shared_resource_group.name
    data_location           = var.data_location

    providers = {
        azurerm = azurerm
    }
}