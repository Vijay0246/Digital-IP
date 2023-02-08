variable "rg_name" {
description     = "The name of the resource group. Must be unique on your Azure subscription"
type            = string
}

variable "lb_name" {
type            = string
}

variable "vnet_name" {
  type          = string
}

variable "lb_pip_name" {
  type          = string
}

variable "lb_frontend_ip_configuration" {
  type          = string
  description   = "This is about to Frontend Public IP Configuration"
}

variable "location" {
  type          = string
  description   = "The location where the resource group should be created. For a list of all Azure locations"
}
