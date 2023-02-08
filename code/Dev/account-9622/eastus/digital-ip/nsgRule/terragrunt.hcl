locals {
  environment_vars              = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env_name                    = local.environment_vars.locals.environment

  account_vars                  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    local_dir                   = local.account_vars.locals.local_dir
    azure_account_id            = local.account_vars.locals.azure_account_id
    azure_account_short_id      = local.account_vars.locals.azure_account_short_id

  project_vars                  = read_terragrunt_config(find_in_parent_folders("project.hcl"))
    nsg_name                    = local.project_vars.locals.nsg_name
    nsgrule_name                = local.project_vars.locals.nsgrule_name
    nsgrule_priority            = local.project_vars.locals.nsgrule_priority
    nsgrule_direction           = local.project_vars.locals.nsgrule_direction
    nsgrule_access              = local.project_vars.locals.nsgrule_access
    nsgrule_protocol            = local.project_vars.locals.nsgrule_protocol
    rg_name                     = local.project_vars.locals.rg_name
    backend-rg                  = local.project_vars.locals.backend-rg
    backend-sa                  = local.project_vars.locals.backend-sa
    backend-container           = local.project_vars.locals.backend-container
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

inputs   = {
    env_name                    = local.env_name
    local_dir                   = local.local_dir
    location                    = local.azure_region
    azure_account_id            = local.azure_account_id
    azure_account_short_id      = local.azure_account_short_id
    project_name                = local.project_name
    nsg_name                    = local.nsg_name
    nsgrule_name                = local.nsgrule_name
    nsgrule_priority            = local.nsgrule_priority
    nsgrule_direction           = local.nsgrule_direction
    nsgrule_access              = local.nsgrule_access
    nsgrule_protocol            = local.nsgrule_protocol
    rg_name                     = local.rg_name 
    backend-rg                  = local.backend-rg
    backend-sa                  = local.backend-sa
    backend-container           = local.backend-container
}

dependencies {
  paths                         = ["../rg", "../nsg"]
}