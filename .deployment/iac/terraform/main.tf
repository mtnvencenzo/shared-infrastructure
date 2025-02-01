# For suggested naming conventions, refer to:
#   https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.16.0"
    }
  }

  backend "azurerm" { }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "global_shared_resource_group" {
  name     = "rg-${var.sub}-${var.region}-${var.environment}-${var.domain}-${var.sequence}"
}

data "azurerm_resource_group" "global_network_resource_group" {
  name     = "rg-${var.sub}-${var.region}-${var.environment}-network-${var.sequence}"
}