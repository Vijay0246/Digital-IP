resource "helm_release" "mt-loki" {
  
  name  = "mt-loki"
  chart = "loki"
  namespace = "loki"
  # version    = "1.11.3"
  repository = "https://grafana.github.io/helm-charts"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.mt-namespace-loki
  ]
}