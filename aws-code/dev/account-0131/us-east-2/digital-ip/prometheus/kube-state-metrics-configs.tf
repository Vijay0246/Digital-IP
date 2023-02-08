resource "kubernetes_cluster_role_binding" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "v1.8.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
}

resource "kubernetes_cluster_role" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "v1.8.0"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets", "nodes", "pods", "services", "resourcequotas", "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes", "namespaces", "endpoints"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }
}

resource "kubernetes_deployment" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "v1.8.0"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kube-state-metrics"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "kube-state-metrics"

          "app.kubernetes.io/version" = "v1.8.0"
        }
      }

      spec {
        container {
          name  = "kube-state-metrics"
          image = "quay.io/coreos/kube-state-metrics:v1.8.0"

          port {
            name           = "http-metrics"
            container_port = 8080
          }

          port {
            name           = "telemetry"
            container_port = 8081
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "8081"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "kube-state-metrics"
      }
    }
  }
  wait_for_rollout = false
}

resource "kubernetes_service_account" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "v1.8.0"
    }
  }
}

resource "kubernetes_service" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"

      "app.kubernetes.io/version" = "v1.8.0"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "telemetry"
      port        = 8081
      target_port = "telemetry"
    }

    selector = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }

    cluster_ip = "None"
  }
}