variable "rg_name" {
    type= string
    description= "resource group name"
}

variable "location" {
    type= string
    description= "desired location"
}

variable "acr_name" {
    type= string
    description= "name for your ARC"
}

variable "sku" {
  type= string
  description= "sku for ACR"
}