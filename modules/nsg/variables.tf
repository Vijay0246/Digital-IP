variable "nsg_name" {
    type        = string
    description = "This is about to create Network Secuirty Group Name"
}

variable "rg_name" {
    type        = string
    description = "The name of the resource group. Must be unique on your Azure subscription"
}

variable "location" {
    type        = string
    description = "The location where the resource group should be created. For a list of all Azure locations"
}