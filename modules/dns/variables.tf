variable "rg_name" {
description     = "The name of the resource group. Must be unique on your Azure subscription"
type            = string
}

variable "location" {
  type          = string
  description   = "Resource Group Location"
}

variable "privatednszone_name" {
  type          = string
}

variable "dnszone_name" {
  type          = string
}
