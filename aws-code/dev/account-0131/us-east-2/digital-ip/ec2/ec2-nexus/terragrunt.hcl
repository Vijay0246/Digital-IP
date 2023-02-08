locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.environment_vars.locals.environment

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  local_dir = local.account_vars.locals.local_dir
  aws_account_id = local.account_vars.locals.aws_account_id


  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  nexus_ami  = local.project_vars.locals.nexus_ami
  nexus_instance_type = local.project_vars.locals.nexus_instance_type
  bastion_keypair_name   = local.project_vars.locals.bastion_keypair_name
  project_name = local.project_vars.locals.project_name
}

terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    env_name = local.env_name
    local_dir = local.local_dir
    aws_region = local.aws_region
    aws_account_id = local.aws_account_id
    nexus_ami  = local.nexus_ami
    nexus_instance_type = local.nexus_instance_type
    bastion_keypair_name   = local.bastion_keypair_name
    project_name = local.project_name

}