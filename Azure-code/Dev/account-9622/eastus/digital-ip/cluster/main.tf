data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name  = var.backend-sa 
    container_name        = var.backend-container 
    key                   = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = data.terraform_remote_state.rg.outputs.location
  resource_group_name = data.terraform_remote_state.rg.outputs.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.aks_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

   tags = {
    "Environment"       = var.env_name
    "Project"           = var.project_name
    "Name"              = "AKS-for-${var.project_name}"
  }
}
