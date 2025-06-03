variable "rg_name" {
    type        =   string
    description = "(Required) The name of the resource group. Must be unique on your Azure subscription"
}
variable "location" {
    type = string
      description     = "The location where the resource group should be created. For a list of all Azure location"
}
variable "dns_prefix" {
    type        =   string
    description     = "dns_prefix name"
}
variable "aks_name" {
    type        =   string
    description     = "aks_name name"
}

variable "aks_vm_size" {
    type        =   string
    description     = "aks_name name"
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