#Create virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-dev-westus-001"
  address_space       = ["10.0.0.0/16"]
  location            = "westus"
  resource_group_name = var.rg-name
}

# Create subnet
resource "azurerm_subnet" "subnet1" {
  name                 = "snet1-dev-westus-001"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

#Create virtual network
resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2-dev-westus-001"
  address_space       = ["10.1.0.0/16"]
  location            = "westus"
  resource_group_name = var.rg-name
}

# Create subnet
resource "azurerm_subnet" "subnet2" {
  name                 = "snet2-dev-westus-001"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
}