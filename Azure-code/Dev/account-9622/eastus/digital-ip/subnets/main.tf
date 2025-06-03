data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key                  = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/vnet/terraform.tfstate"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.terraform_remote_state.rg.outputs.name
  virtual_network_name = data.terraform_remote_state.vnet.outputs.vnet_name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = data.terraform_remote_state.rg.outputs.name
  virtual_network_name = data.terraform_remote_state.vnet.outputs.vnet_name
  address_prefixes     = ["10.0.1.0/24"]
}