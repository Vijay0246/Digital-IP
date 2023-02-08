data "azurerm_resource_group" "rgar" {
  name                = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rgar.name
}

data "azurerm_public_ip" "pip" {
  name                = var.lb_pip_name
  resource_group_name = data.azurerm_resource_group.rgar.name
}

resource "azurerm_lb" "azlb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
   
   frontend_ip_configuration {
    name                 = var.lb_frontend_ip_configuration
    public_ip_address_id = data.azurerm_public_ip.pip.id

  }

}
