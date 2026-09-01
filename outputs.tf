output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.landing_zone.name
}

output "hub_vnet_id" {
  description = "ID of the Hub VNet"
  value       = module.networking.hub_vnet_id
}

output "spoke_vnet_id" {
  description = "ID of the Spoke VNet"
  value       = module.networking.spoke_vnet_id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.governance.log_analytics_workspace_id
}
