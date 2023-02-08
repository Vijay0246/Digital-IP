resource "helm_release" "mt-nexus" {
  name  = "mt-nexus"
  chart = "oteemocharts/sonatype-nexus"
  namespace = "nexus"
  version    = "5.1.2"
  repository = "oteemo.github.io/charts"

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "persistence.existingClaim"
    value = "pvc-efs-nexus"
  }

  set {
    name  = "nexus.service.type"
    value = "LoadBalancer"
  }

  #set {
    #name  = "nexusProxy.env.nexusHttpHost"
    #value = "nexus.co.reefplatform.com"
  #}

  #set {
    #name  = "nexusProxy.env.nexusDockerHost"
    #value = "nexus.co.reefplatform.com"
  #}

  # set {
  #   name  = "nodeSelector.node_size"
  #   value = "m5.2xlarge"
  # }
}