locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  react_ecr_name = local.project_vars.locals.react_ecr_name
}

terraform {

  #source = "/mnt/c/Users/riyajk/Documents/devops/terraform-module/aws-efs"
}

include {
  path = find_in_parent_folders()
}

inputs = {

    react_ecr_name = local.react_ecr_name

}
