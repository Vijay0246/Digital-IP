resource "helm_release" "mt-grafana" {
  
  name  = "mt-grafana"
  chart = "grafana"
  namespace = "grafana"
  # version    = "1.11.3"
  repository = "https://grafana.github.io/helm-charts"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.mt-namespace-grafana
  ]
}