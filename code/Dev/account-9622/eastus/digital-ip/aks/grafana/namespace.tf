resource "kubernetes_namespace" "mt-namespace-grafana" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "grafana"
  }
}
