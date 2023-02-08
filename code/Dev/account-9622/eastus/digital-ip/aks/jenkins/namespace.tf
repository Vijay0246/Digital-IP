resource "kubernetes_namespace" "mt-namespace-jenkins" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "jenkins"
  }
}
