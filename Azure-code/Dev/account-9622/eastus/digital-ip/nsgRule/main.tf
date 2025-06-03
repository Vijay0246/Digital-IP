data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key    = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "nsg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key    = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/nsg/terraform.tfstate"
  }
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
  resource_group_name         = data.terraform_remote_state.rg.outputs.name
  network_security_group_name = data.terraform_remote_state.nsg.outputs.nsg_name
}
