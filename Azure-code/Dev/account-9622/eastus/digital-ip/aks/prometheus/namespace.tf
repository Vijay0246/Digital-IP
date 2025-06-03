resource "kubernetes_namespace" "mt-namespace-prometheus" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "prometheus"
  }
}
