resource "azurerm_resource_group" "rgar" {
  name              = var.rg_name
  location          = var.location

   tags = {
    "Environment"   = var.env_name
    "Project"       = var.project_name
    "Name"          = "Resource-Group-for-${var.project_name}"
  }
}