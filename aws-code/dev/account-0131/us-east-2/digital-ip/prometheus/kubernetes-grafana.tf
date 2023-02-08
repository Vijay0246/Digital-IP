resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        name = "grafana"

        labels = {
          app = "grafana"
        }
      }

      spec {
        volume {
          name = "grafana-storage"
        }

        volume {
          name = "grafana-datasources"

          config_map {
            name         = "grafana-datasources"
            default_mode = "0644"
          }
        }

        container {
          name  = "grafana"
          image = "grafana/grafana:latest"

          port {
            name           = "grafana"
            container_port = 3000
          }

          resources {
            limits {
              cpu    = "1"
              memory = "1Gi"
            }

            requests {
              cpu    = "500m"
              memory = "500M"
            }
          }

          volume_mount {
            name       = "grafana-storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "grafana-datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
          }
        }
      }
    }
  }
  wait_for_rollout = false
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "monitoring"
  }

  data = {
    "prometheus.yaml" = "{\n    \"apiVersion\": 1,\n    \"datasources\": [\n        {\n           \"access\":\"proxy\",\n            \"editable\": true,\n            \"name\": \"prometheus\",\n            \"orgId\": 1,\n            \"type\": \"prometheus\",\n            \"url\": \"http://prometheus-service.monitoring.svc:8080\",\n            \"version\": 1\n        }\n    ]\n}"
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "3000"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 3000
      target_port = "3000"
      node_port   = 32000
    }

    selector = {
      app = "grafana"
    }

    type = "LoadBalancer"
  }
}