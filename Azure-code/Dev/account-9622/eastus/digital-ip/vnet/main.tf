data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key                  = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

resource "azurerm_network_ddos_protection_plan" "vnetsg" {
  name                = var.network_ddos_protection_plan_name
  location            = data.terraform_remote_state.rg.outputs.location
  resource_group_name = data.terraform_remote_state.rg.outputs.name

  tags = {
    "Environment"     = var.env_name
    "Project"         = var.project_name
    "Name"            = "VNet-DDOS-Protectionplan-for-${var.project_name}"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.terraform_remote_state.rg.outputs.location
  resource_group_name = data.terraform_remote_state.rg.outputs.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ddos_protection_plan {
    id                = azurerm_network_ddos_protection_plan.vnetsg.id
    enable            = true
  }

  tags = {
    "Environment"      = var.env_name
    "Project"          = var.project_name
    "Name"             = "Virtual-Network-for-${var.project_name}"
  }
}