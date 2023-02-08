resource "kubernetes_namespace" "mt-namespace-loki" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "loki"
  }
}
