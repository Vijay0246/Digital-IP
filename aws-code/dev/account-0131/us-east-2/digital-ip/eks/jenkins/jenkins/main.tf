resource "helm_release" "mt-jenkins" {
  name  = "mt-jenkins"
  chart = "jenkins"
  namespace = "jenkins"
  version    = "1.10.2"
  repository = "https://charts.jenkins.io"

  # force_update = true

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "persistence.existingClaim"
    value = "pvc-efs-jenkins"
  }

  set {
    name  = "persistence.subPath"
    value = "jenkins"
  }
}