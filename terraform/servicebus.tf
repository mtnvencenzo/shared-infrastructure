module "shared_servicebus_namespace" {
    source                  = "git::https://vecchi@dev.azure.com/vecchi/Latest/_git/Terraform-Modules//modules/servicebus-namespace"
    
    resource_group_name = data.azurerm_resource_group.global_shared_resource_group.name
    location            = data.azurerm_resource_group.global_shared_resource_group.location

    sub                     = var.sub
    region                  = var.region
    environment             = var.environment
    domain                  = var.domain

    providers = {
        azurerm = azurerm
    }
}

