locals {
  environment_vars                      = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env_name                            = local.environment_vars.locals.environment

  account_vars                          = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    local_dir                           = local.account_vars.locals.local_dir
    azure_account_id                    = local.account_vars.locals.azure_account_id
    azure_account_short_id              = local.account_vars.locals.azure_account_short_id

  project_vars                          = read_terragrunt_config(find_in_parent_folders("project.hcl"))
    rg_name                             =  local.project_vars.locals.rg_name
    backend-rg                          = local.project_vars.locals.backend-rg
    backend-sa                          = local.project_vars.locals.backend-sa
    backend-container                   = local.project_vars.locals.backend-container
    vnet_name                           = local.project_vars.locals.vnet_name
    network_ddos_protection_plan_name   = local.project_vars.locals.network_ddos_protection_plan_name
    project_name                        = local.project_vars.locals.project_name

  region_vars                           = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    azure_region                        = local.region_vars.locals.azure_region
}

terraform {
  source                                = "${path_relative_from_include()}"
}

include {
  path                                  = find_in_parent_folders()
}

inputs   = {
    env_name                           = local.env_name
    local_dir                          = local.local_dir
    location                           = local.azure_region
    azure_account_id                   = local.azure_account_id
    azure_account_short_id             = local.azure_account_short_id
    project_name                       = local.project_name
    rg_name                            = local.rg_name
    vnet_name                          = local.vnet_name
    network_ddos_protection_plan_name  = local.network_ddos_protection_plan_name
    backend-rg                         = local.backend-rg
    backend-sa                         = local.backend-sa
    backend-container                  = local.backend-container
}

dependencies {
  paths                                = ["../rg"]
}