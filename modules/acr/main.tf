resource "azurerm_container_registry" "acr-dev" {
  name                     = var.acr_name
  resource_group_name      = var.rg_name
  location                 = var.location
  sku                      = var.sku
  admin_enabled            = false

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
       az acr repository delete --name ${self.name} --image hello-world:calab --yes
    EOT
  }
}

#Import Container Image to Azure Container Registries
resource "null_resource" "image" {

  provisioner "local-exec" {
    command = <<EOT
       az acr import --name ${azurerm_container_registry.acr-dev.name} --source docker.io/library/hello-world:latest --image hello-world:calab
    EOT
  }
}

