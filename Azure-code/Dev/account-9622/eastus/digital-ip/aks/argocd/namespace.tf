resource "kubernetes_namespace" "mt-namespace-argocd" {
  metadata {
    labels    = {
      mylabel = "mt-namespace"
    }
    name      = "argocd"
  }
}
