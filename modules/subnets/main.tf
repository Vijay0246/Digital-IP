data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
 }

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "bation_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = data.azurerm_resource_group.rgar.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rgar.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}