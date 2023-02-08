resource "helm_release" "mt-jenkins" {
  name  = "mt-jenkins"
  chart = "jenkins"
  namespace = "jenkins"
  repository = "https://charts.jenkins.io"


  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [
   kubernetes_namespace.mt-namespace-jenkins

  ]
}