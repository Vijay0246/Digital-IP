resource "helm_release" "mt-ingress-nginx" {
  
  name  = "mt-ingress-nginx"
  chart = "ingress-nginx/ingress-nginx"
  namespace = "ingress-nginx"
  # version    = "1.11.3"
  repository = "https://kubernetes.github.io/ingress-nginx"

  values = [
    "${file("values.yaml")}"
  ]
}