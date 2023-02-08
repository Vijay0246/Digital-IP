variable "pip_name" {
  description   = "This is about Public IP Name"
  type          = string
}

variable "rg_name" {
description     = "The name of the resource group. Must be unique on your Azure subscription"
type            = string
}

variable "location" {
  type          = string
  description   = "Resource Group Location"
}

variable "pip_allocation_method" {
  type          = string
}