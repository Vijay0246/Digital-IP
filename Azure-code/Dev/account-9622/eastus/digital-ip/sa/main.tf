data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name   = var.backend-rg
    storage_account_name = var.backend-sa 
    container_name       = var.backend-container 
    key    = "${var.env_name}/${var.local_dir}/${var.azure_region}/${var.project_name}/rg/terraform.tfstate"
  }
}

resource "azurerm_storage_account" "stracc" {
  name                     = var.sa_name
  resource_group_name      = data.terraform_remote_state.rg.outputs.name
  location                 = var.location
  account_tier             = var.sa_tier
  account_replication_type = var.storage_replication_type

  tags = {
    "Environment"      = var.env_name
    "Project" = var.project_name
    "Name" = "StorageAccount-for-${var.project_name}"
  }
}