variable "subnet_name" {
    type        = string
    description = "The name of Subnet name for VNet"
}

variable "bastion_subnet_name" {
    type        = string
    description = "The name of Subnet name for VNet"
}

variable "rg_name" {
    type        = string
   description  = "(Required) The name of the resource group. Must be unique on your Azure subscription"
  
}

variable "vnet_name" {
  type          = string
  description   = "The name of  VNet"
}

variable "location" {
  type          = string
  description   = "The location where the resource group should be created. For a list of all Azure location"
}