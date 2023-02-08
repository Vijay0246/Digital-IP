data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
}

resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = data.azurerm_resource_group.rgar.name
  location            = var.location
  allocation_method   = var.pip_allocation_method
}