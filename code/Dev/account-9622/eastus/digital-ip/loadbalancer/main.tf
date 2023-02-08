data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
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

resource "azurerm_lb" "azlb" {
  name                    = var.lb_name
  location                = data.terraform_remote_state.rg.outputs.location
  resource_group_name     = data.terraform_remote_state.rg.outputs.name
   
   frontend_ip_configuration {
    name                  = var.lb_frontend_ip_configuration
    public_ip_address_id  = data.terraform_remote_state.pip.outputs.pip_loadbalacner_id

  }

  tags = {
    "Environment"         = var.env_name
    "Project"             = var.project_name
    "Name"                = "LoadBalancer-for-${var.project_name}"
  }

}
