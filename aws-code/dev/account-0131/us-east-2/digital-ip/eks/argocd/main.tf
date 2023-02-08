resource "helm_release" "mt-argocd" {
  name  = "mt-argocd"
  chart = "argo-cd"
  namespace = "argocd"
  version    = "2.0.3"
  repository = "https://argoproj.github.io/argo-helm"

  values = [
    "${file("values.yaml")}"
  ]

}