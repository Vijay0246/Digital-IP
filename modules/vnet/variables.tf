variable "nsg_name" {
  type            = string
  description     = "Name of your Azure Virtual Network"
}

variable "rg_name" {
    type          = string
    description   = "(Required) The name of the resource group. Must be unique on your Azure subscription"
}

variable "network_ddos_protection_plan_name" {
  type            = string
  description  = ""    
}

variable "vnet_name" {
  type            = string
  description     = "The name of Virtual Network"
}

variable "location" {
  type            = string
  description     = "The location where the resource group should be created. For a list of all Azure location"
}