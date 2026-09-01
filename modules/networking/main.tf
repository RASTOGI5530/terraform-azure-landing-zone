# ===========================================================
# Networking Module — Hub-Spoke Topology
# Creates: Hub VNet, Spoke VNet, VNet Peering, Subnets, NSGs
# ===========================================================

# ---------------- Hub VNet ----------------
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  address_space       = [var.hub_vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "hub_shared" {
  name                 = "snet-hub-shared"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 8, 0)]
}

# ---------------- Spoke VNet ----------------
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke"
  address_space       = [var.spoke_vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "spoke_workload" {
  name                 = "snet-spoke-workload"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_vnet_cidr, 8, 0)]
}

# ---------------- VNet Peering (Hub <-> Spoke) ----------------
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name      = var.resource_group_name
  virtual_network_name     = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name      = var.resource_group_name
  virtual_network_name     = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# ---------------- Network Security Group for Spoke ----------------
resource "azurerm_network_security_group" "spoke_nsg" {
  name                = "nsg-spoke-workload"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "spoke_nsg_assoc" {
  subnet_id                 = azurerm_subnet.spoke_workload.id
  network_security_group_id = azurerm_network_security_group.spoke_nsg.id
}
