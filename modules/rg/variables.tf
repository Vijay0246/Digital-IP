variable "rg_name" {
  type        = string
  description = "(Required) The name of the resource group. Must be unique on your Azure subscription"
}

variable "location" {
  type        = string
  description = "(Required) The location where the resource group should be created. For a list of all Azure locations"
}

