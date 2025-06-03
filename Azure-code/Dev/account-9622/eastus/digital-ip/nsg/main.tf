data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key    = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = data.terraform_remote_state.rg.outputs.location
  resource_group_name = data.terraform_remote_state.rg.outputs.name

  tags = {
    "Environment"     = var.env_name
    "Project"         = var.project_name
    "Name"            = "NetworkSecurityGroup-for-${var.project_name}"
  }
}