data "azurerm_resource_group" "rgar" {
    name                   = var.rg_name
}

data "azurerm_network_security_group" "nsg" {
    name                    = var.nsg_name
    resource_group_name     = data.azurerm_resource_group.rgar.name
}

resource "azurerm_network_security_rule" "nsgrule" {
  name                        = var.nsgrule_name
  priority                    = var.nsgrule_priority
  direction                   = var.nsgrule_direction
  access                      = var.nsgrule_access
  protocol                    = var.nsgrule_protocol
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = data.azurerm_network_security_group.nsg.name
}
