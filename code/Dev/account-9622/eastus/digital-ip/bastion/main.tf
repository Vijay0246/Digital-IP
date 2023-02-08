data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnets" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/subnets/terraform.tfstate"
  }
}

data "terraform_remote_state" "pip" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/pip/terraform.tfstate"
  }
}

resource "azurerm_bastion_host" "bastion" {
  name                   = var.bastion_host_name
  location               = data.terraform_remote_state.rg.outputs.location
  resource_group_name    = data.terraform_remote_state.rg.outputs.name

  ip_configuration {
    name                 = var.bastion_ip_configuration 
    subnet_id            = data.terraform_remote_state.subnets.outputs.bastion_subnet_id
    public_ip_address_id = data.terraform_remote_state.pip.outputs.pip_bastion_id
  }
  tags = {
    "Environment"        = var.env_name
    "Project"            = var.project_name
    "Name"               = "BastionHost-for-${var.project_name}"
  }
}