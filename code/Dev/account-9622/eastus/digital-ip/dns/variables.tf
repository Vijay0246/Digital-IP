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

variable "env_name" {
  type        = string
  description = "Type of environment ex: dev, stage or prod"
}

variable "local_dir" {
  type        = string
  description = "local account directory name"
}

variable "azure_region" {
  type        = string
  description = "azure region"
}

variable "project_name" {
  type        = string
  description = "project name"
}

variable "backend-rg" {
  type        = string
  description = "Backend resource group where remote state is stored"
}

variable "backend-sa" {
  type        = string
  description = "Backend storage account where remote state is stored"
}

variable "backend-container" {
  type        = string
  description = "Backend conatiner where remote state is stored"
}