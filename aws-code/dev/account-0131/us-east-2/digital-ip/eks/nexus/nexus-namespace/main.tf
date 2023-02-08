resource "kubernetes_namespace" "mt-namespace" {
  metadata {
    annotations = {
      name = "mt-namespace-annotation"
    }

    labels = {
      mylabel = "mt-namespace"
    }

    name = "nexus"
  }
}