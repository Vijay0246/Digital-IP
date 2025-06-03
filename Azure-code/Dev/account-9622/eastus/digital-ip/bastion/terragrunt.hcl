locals {
  environment_vars              = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env_name                    = local.environment_vars.locals.environment

  account_vars                  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    local_dir                   = local.account_vars.locals.local_dir
    azure_account_id            = local.account_vars.locals.azure_account_id
    azure_account_short_id      = local.account_vars.locals.azure_account_short_id

  project_vars                  = read_terragrunt_config(find_in_parent_folders("project.hcl"))
    bastion_pip_name            = local.project_vars.locals.bastion_pip_name
    bastion_host_name           = local.project_vars.locals.bastion_host_name
    pip_sku                     = local.project_vars.locals.pip_sku
    bastion_ip_configuration    = local.project_vars.locals.bastion_ip_configuration
    rg_name                     = local.project_vars.locals.rg_name
    backend-rg                  = local.project_vars.locals.backend-rg
    backend-sa                  = local.project_vars.locals.backend-sa
    backend-container           = local.project_vars.locals.backend-container
    pip_allocation_method       = local.project_vars.locals.pip_allocation_method
    bastion_subnet_name         = local.project_vars.locals.bastion_subnet_name
    vnet_name                   = local.project_vars.locals.vnet_name
    project_name                = local.project_vars.locals.project_name

  region_vars                   = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    azure_region                = local.region_vars.locals.azure_region
}

terraform {
  source                        = "${path_relative_from_include()}"
}

include {
  path                          = find_in_parent_folders()
}

inputs = {
    env_name                    = local.env_name
    local_dir                   = local.local_dir
    location                    = local.azure_region
    azure_account_id            = local.azure_account_id
    azure_account_short_id      = local.azure_account_short_id
    project_name                = local.project_name
    bastion_pip_name            = local.bastion_pip_name
    bastion_host_name           = local.bastion_host_name
    pip_sku                     = local.pip_sku
    bastion_ip_configuration    = local.bastion_ip_configuration
    rg_name                     = local.rg_name 
    backend-rg                  = local.backend-rg
    backend-sa                  = local.backend-sa
    backend-container           = local.backend-container
    bastion_subnet_name         = local.bastion_subnet_name
    vnet_name                   = local.vnet_name
}

dependencies {
  paths                         = ["../rg", "../vnet", "../subnets","../pip"]
}