variable "rg_name" {
  type        = string
  description = "(Required) The name of the resource group. Must be unique on your Azure subscription"
}

variable "location" {
  type        = string
  description = "(Required) The location where the resource group should be created. For a list of all Azure locations"
}

variable "vnet_name" {
  type            = string
  description     = "The name of Virtual Network"
}

variable "subnet_name" {
    type        = string
    description = "The name of Subnet name for VNet"
}

variable "nic_name" {
    type        = string
    description = "This is about Azure Network Interface "
}

variable "ip_config_name" {
    type        = string
    description = "This is about Network Interface IP Configuration Name"
}

variable "vm_name"{
    type        = string
    description = "Virtual Machine name"
}

variable "sa_name" {
    type            = string
    description     = "This is about storage account name"
}
variable "vm_pip" {
  type = string
}
variable "nsg_name" {
  type = string
}