data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

resource "azurerm_public_ip" "bastion_publicip" {
  name                = var.bastion_pip_name
  location            = data.terraform_remote_state.rg.outputs.location
  resource_group_name = data.terraform_remote_state.rg.outputs.name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku

   tags = {
    "Environment"     = var.env_name
    "Project"         = var.project_name
    "Name"            = "Bastion-publicip-for-${var.project_name}"
  } 
}

resource "azurerm_public_ip" "loadbalancer_pip" {
  name                = var.lb_pip_name
  resource_group_name = data.terraform_remote_state.rg.outputs.name
  location            = data.terraform_remote_state.rg.outputs.location
  allocation_method   = var.pip_allocation_method

  tags = {
    "Environment"     = var.env_name
    "Project"         = var.project_name
    "Name"            = "LoadBalancer-Publicip-for-${var.project_name}"
  }
}