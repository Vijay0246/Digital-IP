resource "helm_release" "mt-prometheus" {
  name  = "mt-prometheus"
  chart = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace = "prometheus"
  depends_on = [
    kubernetes_namespace.mt-namespace-prometheus
  ]

    values = [
    "${file("values.yaml")}"
  ]

}