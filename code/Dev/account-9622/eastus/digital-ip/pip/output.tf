output "pip_loadbalacner_id" {
  value       = azurerm_public_ip.loadbalancer_pip.id
  description = "Public IP ID of Loadbalacner"
}

output "pip_bastion_id" {
  value       = azurerm_public_ip.bastion_publicip.id
  description = "Public IP ID of Bastion host"
}