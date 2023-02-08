# Terraform
terraform {
  required_providers {
    azurerm = {
      source              = "hashicorp/azurerm"
      version             = "2.40.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "Digital-IP"
    storage_account_name  = "digitalipsa"
    container_name        = "backend"
    key                   = "digitalip-terraform.tfstate"
  }
}

#Azure provider
provider "azurerm" {
  features {}
}

#Create Resource Group
module "resource_group" {
source = "./modules/rg/"

rg_name                  =   "rg_digitalip"
location                 =   "eastus2"
}

#create vnet
module "vnet" {
source                    = "./modules/vnet/" 

rg_name                   =   "rg_digitalip"
location                  =   "eastus2"  
vnet_name                 =   "vnet_digitalip"
nsg_name                  =   "nsg_digitalip"
network_ddos_protection_plan_name= "ddos_digitalip"
depends_on = [module.resource_group]
}

#create subnet
module "subnets" {
  source = "./modules/subnets/"

  rg_name                  =   "rg_digitalip"
  location                 =   "eastus2"  
  vnet_name                =   "vnet_digitalip"
  subnet_name              =   "default"
  bastion_subnet_name      =   "AzureBastionSubnet"
  depends_on = [module.resource_group,module.vnet]
}

#create storage account
module "storageAccount" {
  source = "./modules/storageAccount/"

  rg_name                   =   "rg_digitalip"
  location                  =   "eastus2"
  sa_name                   =   "sadigitalip"
  sa_tier                   =   "Standard"
  storage_replication_type= "GRS"
  depends_on = [module.resource_group]
}

#create public ip
module "pip" {
  source = "./modules/pip/"

  rg_name                    =   "rg_digitalip"
  location                   =   "eastus2"
  pip_name                   =   "pip_digitalip"
  pip_allocation_method= "Static"
  depends_on = [module.resource_group]
}

#create network security group
module "nsg" {
  source = "./modules/nsg/"

 rg_name                      =   "rg_digitalip"
 location                     =   "eastus2"
 nsg_name                     =   "nsg_digitalip"
 depends_on = [module.resource_group]
}

#create network security rule
module "nsgRule" {
  source = "./modules/nsgRule/"

  rg_name                     = "rg_digitalip"
  nsg_name                    = "nsg_digitalip"
  nsgrule_name                = "nsgrule_digitalip"
  nsgrule_priority            = "100"
  nsgrule_direction           = "inbound"
  nsgrule_access              = "Allow"
  nsgrule_protocol            = "TCP"
  depends_on = [module.resource_group,module.nsg]
}

#create load balancer
module "loadbalancer" {
  source = "./modules/loadbalancer/"

  rg_name                      =   "rg_digitalip"
  location                     =   "eastus2"  
  vnet_name                    =   "vnet_digitalip"
  lb_name                      =   "lb_digitalip"
  lb_pip_name                  =   "pip_digitalip"
  lb_frontend_ip_configuration =   "config_digitalip"
  depends_on = [module.resource_group,module.vnet,module.pip]
}

#create dns
module "dns" {
  source = "./modules/dns/"

  rg_name                        =   "rg_digitalip"
  location                       =   "eastus2"
  privatednszone_name            =   "privatedns.com"
  dnszone_name                   =   "dns.com"
  depends_on = [module.resource_group]
}

#create bastion host
module "bastion" {
  source = "./modules/bastion/"

  rg_name                        =    "rg_digitalip"
  location                       =    "eastus2"  
  vnet_name                      =    "vnet_digitalip"
  subnet_name                    =    "AzureBastionSubnet"
  bastion_pip_name               =    "bastion_pip"
  bastion_host_name              =    "bastion_digitalip"
  pip_allocation_method          =     "Static"
  pip_sku                        =     "Standard"
  bastion_ip_configuration       =     "config_bastion"
  depends_on = [module.resource_group,module.vnet,module.subnets]
}

#create acr
module "acr" {
  source = "./modules/acr/"
  rg_name                        =    "rg_digitalip"
  location                       =    "eastus2"  
  acr_name                       =    "acrdigitalip"  
  sku                            =    "Premium"
  depends_on = [module.resource_group]  
}