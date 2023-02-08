locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.environment_vars.locals.environment

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  local_dir = local.account_vars.locals.local_dir
  aws_account_id = local.account_vars.locals.aws_account_id


  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project_name = local.project_vars.locals.project_name
}

include {
  path = find_in_parent_folders()
}

# Refactoring needed at a later stage with subnets and security groups - these should come 
# from outputs or state of dependent components.
inputs = {
  # By default encryption is set to false even if you don't specify the below param. Set the below param to true to enable encryption.
  # encrypted = false 
  env_name = local.env_name
  local_dir = local.local_dir
  aws_region = local.aws_region
  aws_account_id = local.aws_account_id
  project_name = local.project_name
}


