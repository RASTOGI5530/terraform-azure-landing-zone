terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------------------------------------
# Resource Group for the Landing Zone
# ---------------------------------------------------------
resource "azurerm_resource_group" "landing_zone" {
  name     = var.resource_group_name
  location = var.location

  tags = var.default_tags
}

# ---------------------------------------------------------
# Networking Module — Hub-Spoke topology
# ---------------------------------------------------------
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location             = azurerm_resource_group.landing_zone.location
  hub_vnet_cidr        = var.hub_vnet_cidr
  spoke_vnet_cidr      = var.spoke_vnet_cidr
  tags                 = var.default_tags
}

# ---------------------------------------------------------
# Governance Module — Policy + Log Analytics
# ---------------------------------------------------------
module "governance" {
  source = "./modules/governance"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location             = azurerm_resource_group.landing_zone.location
  tags                 = var.default_tags
}
