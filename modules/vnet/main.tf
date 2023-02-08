data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
}

resource "azurerm_network_security_group" "vnetsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
}

resource "azurerm_network_ddos_protection_plan" "vnetsg" {
  name                = var.network_ddos_protection_plan_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.vnetsg.id
    enable = true
  }
}