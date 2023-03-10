
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

resource "azurerm_resource_group" "rg-a" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.resource_group_tags
}