terraform {
  source = "${path_relative_from_include()}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  pvc_sonarqube_data = "pvc-efs-sonarqube-data"
  pvc_sonarqube_extensions = "pvc-efs-sonarqube-extensions"
}