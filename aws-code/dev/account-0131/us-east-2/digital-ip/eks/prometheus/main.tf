resource "helm_release" "mt-prometheus" {
  name  = "mt-prometheus"
  chart = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace = "prometheus"
  version    = "13.4.0"

  values = [
    "${file("values.yaml")}"
  ]
}