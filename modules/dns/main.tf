data "azurerm_resource_group" "rgar" {
  name     = var.rg_name
}

resource "azurerm_dns_zone" "dnszone" {
  name                = var.dnszone_name
  resource_group_name = data.azurerm_resource_group.rgar.name
}

resource "azurerm_private_dns_zone" "privatednszone" {
  name                = var.privatednszone_name
  resource_group_name = data.azurerm_resource_group.rgar.name
}