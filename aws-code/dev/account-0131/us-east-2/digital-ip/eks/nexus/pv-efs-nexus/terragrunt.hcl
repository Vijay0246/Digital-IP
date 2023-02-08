terraform {
  source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/pv"
}
dependency "efs-jenkins" {
  config_path = "../../nexus/efs-nexus"
}

inputs = {
    pv_name = "pv-efs-nexus"
    storage_class_name  = "sc-efs-nexus"
    persistent_volume_reclaim_policy  = "Retain"
    storage_size  = "50Gi"
    access_modes  = ["ReadWriteMany"]
    path = "/"
    efs_server = dependency.efs-jenkins.outputs.efs_dns
}
