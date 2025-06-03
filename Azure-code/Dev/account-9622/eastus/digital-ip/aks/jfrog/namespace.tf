resource "kubernetes_namespace" "mt-namespace-jfrog" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "jfrog"
  }
}
