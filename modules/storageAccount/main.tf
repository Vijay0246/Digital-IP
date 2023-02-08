data "azurerm_resource_group" "rgar" {
  name                    = var.rg_name
 }

resource "azurerm_storage_account" "stracc" {
  name                     = var.sa_name
  resource_group_name      = data.azurerm_resource_group.rgar.name
  location                 = var.location
  account_tier             = var.sa_tier
  account_replication_type = var.storage_replication_type

  tags = {
    environment = "Digital-IP"
  }
}