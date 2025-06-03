resource "helm_release" "mt-jfrog" {
  
  name  = "mt-jfrog"
  chart = "artifactory"
  namespace = "jfrog"
  # version    = "1.11.3"
  repository = "https://charts.jfrog.io"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.mt-namespace-jfrog
  ]
}