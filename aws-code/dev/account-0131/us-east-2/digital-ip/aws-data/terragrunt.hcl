terraform {

  source = "/Users/colvera/MOURITECH/devops/terraform-module/aws-data"
}

include {
  path = find_in_parent_folders()
}

inputs = {}
