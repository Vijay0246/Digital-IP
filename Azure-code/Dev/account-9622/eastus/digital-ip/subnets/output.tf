output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "Subnet ID"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion_subnet.id
  description = "Bastion Subnet ID"
}