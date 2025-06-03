resource "helm_release" "mt-sonarqube" {
  name       = "mt-sonarqube"
  chart      = "sonarqube"
  namespace  = "sonarqube"
  repository = "https://oteemo.github.io/charts"
  timeout    = 1800


  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
   kubernetes_namespace.mt-namespace-sonarqube

  ]
}