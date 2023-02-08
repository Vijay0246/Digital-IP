data "azurerm_resource_group" "rgar" {
  name                 = var.rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                 = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rgar.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rgar.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "publicip" {
  name                = var.bastion_pip_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rgar.name
  allocation_method   = var.pip_allocation_method 
  sku                 = var.pip_sku 
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = var.bastion_ip_configuration 
    subnet_id            = data.azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}