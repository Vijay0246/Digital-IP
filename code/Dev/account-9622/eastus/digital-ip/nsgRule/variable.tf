variable "nsg_name" {
    type = string
}

variable "nsgrule_priority" {
    type = number
}

variable "nsgrule_direction" {
    type = string
}

variable "nsgrule_access" {
    type = string
}

variable "nsgrule_protocol" {
    type = string
}

variable "rg_name" {
    type = string 
}

variable "nsgrule_name" {
    type = string
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