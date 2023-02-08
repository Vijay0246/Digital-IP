variable "rg_name" {
    type        =   string
    description = "(Required) The name of the resource group. Must be unique on your Azure subscription"
}

variable "vnet_name" {
    type        =   string
    description = "The name of Virtual Network"
}

variable "subnet_name" {
    type        =   string
    description = "The name of the subnet must be a AzureBastionSubnet" 
}

variable "bastion_pip_name" {
    type        =   string
    description = "The name of Bastion Server Public name"
}

variable "bastion_host_name" {
    type        =   string
    description = "The name of Bastion Host Name"
}

variable "location" {
    type = string
      description     = "The location where the resource group should be created. For a list of all Azure location"
}

variable "pip_allocation_method" {
    type = string
    description     = "static or dynamic"

}

variable "pip_sku" {
    type = string
    description = "Standard"
}

variable "bastion_ip_configuration" {
    type = string
}