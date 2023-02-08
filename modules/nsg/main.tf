
data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
}