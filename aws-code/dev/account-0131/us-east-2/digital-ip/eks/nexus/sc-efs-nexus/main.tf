resource "kubernetes_storage_class" "sc-efs-nexus" {
  metadata {
    name = "sc-efs-nexus"
  }
  storage_provisioner = "kubernetes.io/eks-sc"
  reclaim_policy      = "Retain"
  parameters = {
    type = "pd-standard"
  }
  # mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}
