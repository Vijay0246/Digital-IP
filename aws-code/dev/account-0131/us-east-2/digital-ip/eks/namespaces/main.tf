resource "kubernetes_namespace" "mt-namespace" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "jenkins"
  }
}
