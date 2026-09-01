variable "resource_group_name" {
  description = "Name of the resource group for the landing zone"
  type        = string
  default     = "rg-landing-zone-demo"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "centralindia"
}

variable "hub_vnet_cidr" {
  description = "CIDR block for the Hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the Spoke VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "default_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "Demo"
    Project     = "Landing-Zone"
    ManagedBy   = "Terraform"
  }
}
