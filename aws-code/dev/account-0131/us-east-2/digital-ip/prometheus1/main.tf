resource "helm_release" "reef-prometheus" {
  name  = "reef-prometheus"
  chart = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace = "monitoring"
  version    = "13.4.0"

  values = [
    "${file("values.yaml")}"
  ]
}