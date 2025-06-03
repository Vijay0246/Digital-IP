resource "helm_release" "mt-ingress-nginx" {
  
  name         = "mt-ingress-nginx"
  chart        = "ingress-nginx"
  namespace    = "ingress-nginx"
  # version    = "1.11.3"
  repository   = "https://kubernetes.github.io/ingress-nginx"
    timeout    = 1800


  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.mt-namespace-ingress
  ]
}