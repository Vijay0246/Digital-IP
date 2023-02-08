terraform {
  source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/pv"
}
dependency "efs-sonarqube" {
  config_path = "../../../sonarqube/efs-sonarqube"
}

inputs = {
    pv_name = "pv-efs-sonarqube-data"
    storage_class_name  = "sc-efs-sonarqube"
    persistent_volume_reclaim_policy  = "Retain"
    storage_size  = "50Gi"
    access_modes  = ["ReadWriteMany"]
    path = "/"
    efs_server = dependency.efs-sonarqube.outputs.efs_dns
}
