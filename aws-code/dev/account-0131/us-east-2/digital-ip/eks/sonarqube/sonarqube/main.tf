resource "kubernetes_deployment" "mt-sonarqube" {
  metadata {
    name = "mt-sonarqube"
    namespace = "sonarqube"
    labels = {
      app = "mt-sonarqube"
    }
  }

  spec {

    replicas = 1

    selector {
      match_labels = {
        app = "mt-sonarqube"
      }
    }

    template {
      metadata {
        labels = {
          app = "mt-sonarqube"
        }
      }

      spec {
        container {
          image = "sonarqube:8.9.0-community"
          name  = "sonarqube"

          resources {
            limits = {
              cpu    = "2000m"
              memory = "4096Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "4096Mi"
            }
          }

          port {
            name           = "http"
            container_port = 9000
            protocol       = "TCP"
          }

          env {
              name  = "SONARQUBE_JDBC_USERNAME"
              value = "sonarqube_db"
            }

          
          env {
              name = "sonar.search.javaAdditionalOpts"
              value = "-Dnode.store.allow_mmapfs=false"
          }

          env {
              name  = "SONARQUBE_JDBC_URL"
              value = "jdbc:postgresql://sonarqubepg.cvnyj1fppjqy.us-east-2.rds.amazonaws.com/sonarqubepg"
            }
          env {
              name  = "SONARQUBE_JDBC_PASSWORD"
              value = "iebaeYi9ooxae4lech7Eelu1poy1ae"
            }
          

          volume_mount {
             mount_path = "/opt/sonarqube/data/"
             name = "sonar-data"
          }

          volume_mount {
             mount_path = "/opt/sonarqube/extensions/"
             name = "sonar-extensions"
          }
        }

        volume {
          name = "sonar-data"
          persistent_volume_claim {
            claim_name = var.pvc_sonarqube_data
          }
        }

        volume {
          name = "sonar-extensions"
          persistent_volume_claim {
            claim_name = var.pvc_sonarqube_extensions
          }
        }        
      }
    }
  }
}

resource "kubernetes_service" "mt-sonarqube-svc" {
  metadata {
    name = "sonarqube-svc"
    namespace = "sonarqube"
  }
  spec {
    selector = {
      app = "mt-sonarqube"
    }

    port {
      port = 80
      target_port = 9000
    }
    type = "ClusterIP"
  }
}