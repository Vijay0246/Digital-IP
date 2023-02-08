resource "kubernetes_namespace" "mt-namespace-ingress" {
  metadata {
    labels = {
      mylabel = "mt-namespace"
    }
    name = "ingress-nginx"
  }
}
