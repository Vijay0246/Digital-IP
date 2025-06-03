resource "kubernetes_namespace" "mt-namespace-sonarqube" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "sonarqube"
  }
}
