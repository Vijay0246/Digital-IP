terraform {
  source = "/Users/pavanwadhe/Downloads/Mouritech Work/Devops/terraform-module/pvc_efs_sc"
}

inputs = {
  pvc_name =  "pvc-efs-jenkins"
  storage_size  = "50Gi"
  access_modes  = ["ReadWriteMany"]
  storage_class_name  = "sc-efs-jenkins"
  pv_name = "pv-efs-jenkins"
  namespace = "jenkins"
}