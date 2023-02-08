terraform {
source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/pvc_efs_sc"
}

inputs = {
  pvc_name = "pvc-efs-sonarqube-extensions"
  storage_size = "50Gi"
  access_modes = ["ReadWriteMany"]
  storage_class_name = "sc-efs-sonarqube"
  namespace = "sonarqube"
  pv_name = "pv-efs-sonarqube-extension"
}