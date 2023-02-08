output "name" {
  value       = "${azurerm_resource_group.rgar.name}"
  description = "The resource group name"
}

output "location" {
  value       = "${var.location}"
  description = "The location where the resource group has be created."
}

