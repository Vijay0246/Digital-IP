locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = local.environment_vars.locals.environment

  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  domain = local.project_vars.locals.domain_name
  project_name = local.project_vars.locals.project_name
  #subject_alternative_names = local.domain_vars.locals.subject_alternative_names

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  local_dir = local.account_vars.locals.local_dir
  aws_account_id = local.account_vars.locals.aws_account_id

   aws_account_short_id = local.account_vars.locals.aws_account_short_id

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region = local.region_vars.locals.aws_region

  use_existing_route53_zone = true



  # Removing trailing dot from domain - just to be sure :)
  domain_name = trimsuffix(local.domain, ".")
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
    domain_name = local.domain_name
    aws_account_short_id = local.aws_account_short_id
    use_existing_route53_zone = local.use_existing_route53_zone
    project_name = local.project_name

}