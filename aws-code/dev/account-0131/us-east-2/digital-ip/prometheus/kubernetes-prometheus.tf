resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus" {
  metadata {
    name = "prometheus"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "monitoring"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus"
  }
}

resource "kubernetes_config_map" "prometheus_server_conf" {
  metadata {
    name      = "prometheus-server-conf"
    namespace = "monitoring"

    labels = {
      name = "prometheus-server-conf"
    }
  }

  data = {
    "prometheus.rules" = "groups:\n- name: devopscube demo alert\n  rules:\n  - alert: High Pod Memory\n    expr: sum(container_memory_usage_bytes) > 1\n    for: 1m\n    labels:\n      severity: slack\n    annotations:\n      summary: High Memory Usage"

    "prometheus.yml" = "global:\n  scrape_interval: 5s\n  evaluation_interval: 5s\nrule_files:\n  - /etc/prometheus/prometheus.rules\nalerting:\n  alertmanagers:\n  - scheme: http\n    static_configs:\n    - targets:\n      - \"alertmanager.monitoring.svc:9093\"\n\nscrape_configs:\n  - job_name: 'node-exporter'\n    kubernetes_sd_configs:\n      - role: endpoints\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_endpoints_name]\n      regex: 'node-exporter'\n      action: keep\n  \n  - job_name: 'kubernetes-apiservers'\n\n    kubernetes_sd_configs:\n    - role: endpoints\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]\n      action: keep\n      regex: default;kubernetes;https\n\n  - job_name: 'kubernetes-nodes'\n\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    kubernetes_sd_configs:\n    - role: node\n\n    relabel_configs:\n    - action: labelmap\n      regex: __meta_kubernetes_node_label_(.+)\n    - target_label: __address__\n      replacement: kubernetes.default.svc:443\n    - source_labels: [__meta_kubernetes_node_name]\n      regex: (.+)\n      target_label: __metrics_path__\n      replacement: /api/v1/nodes/$${1}/proxy/metrics     \n  \n  - job_name: 'kubernetes-pods'\n\n    kubernetes_sd_configs:\n    - role: pod\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]\n      action: keep\n      regex: true\n    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]\n      action: replace\n      target_label: __metrics_path__\n      regex: (.+)\n    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]\n      action: replace\n      regex: ([^:]+)(?::\\d+)?;(\\d+)\n      replacement: $1:$2\n      target_label: __address__\n    - action: labelmap\n      regex: __meta_kubernetes_pod_label_(.+)\n    - source_labels: [__meta_kubernetes_namespace]\n      action: replace\n      target_label: kubernetes_namespace\n    - source_labels: [__meta_kubernetes_pod_name]\n      action: replace\n      target_label: kubernetes_pod_name\n  \n  - job_name: 'kube-state-metrics'\n    static_configs:\n      - targets: ['kube-state-metrics.kube-system.svc.cluster.local:8080']\n\n  - job_name: 'kubernetes-cadvisor'\n\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    kubernetes_sd_configs:\n    - role: node\n\n    relabel_configs:\n    - action: labelmap\n      regex: __meta_kubernetes_node_label_(.+)\n    - target_label: __address__\n      replacement: kubernetes.default.svc:443\n    - source_labels: [__meta_kubernetes_node_name]\n      regex: (.+)\n      target_label: __metrics_path__\n      replacement: /api/v1/nodes/$${1}/proxy/metrics/cadvisor\n  \n  - job_name: 'kubernetes-service-endpoints'\n\n    kubernetes_sd_configs:\n    - role: endpoints\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]\n      action: keep\n      regex: true\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]\n      action: replace\n      target_label: __scheme__\n      regex: (https?)\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]\n      action: replace\n      target_label: __metrics_path__\n      regex: (.+)\n    - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]\n      action: replace\n      target_label: __address__\n      regex: ([^:]+)(?::\\d+)?;(\\d+)\n      replacement: $1:$2\n    - action: labelmap\n      regex: __meta_kubernetes_service_label_(.+)\n    - source_labels: [__meta_kubernetes_namespace]\n      action: replace\n      target_label: kubernetes_namespace\n    - source_labels: [__meta_kubernetes_service_name]\n      action: replace\n      target_label: kubernetes_name"
  }
}

resource "kubernetes_deployment" "prometheus_deployment" {
  metadata {
    name      = "prometheus-deployment"
    namespace = "monitoring"

    labels = {
      app = "prometheus-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus-server"
        }
      }

      spec {
        volume {
          name = "prometheus-config-volume"

          config_map {
            name         = "prometheus-server-conf"
            default_mode = "0644"
          }
        }

        volume {
          name = "prometheus-storage-volume"
        }

        container {
          name  = "prometheus"
          image = "prom/prometheus"
          args  = ["--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus/"]

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "prometheus-config-volume"
            mount_path = "/etc/prometheus/"
          }

          volume_mount {
            name       = "prometheus-storage-volume"
            mount_path = "/prometheus/"
          }
        }
      }
    }
  }
  wait_for_rollout = false
}

resource "kubernetes_ingress" "prometheus_ui" {
  metadata {
    name      = "prometheus-ui"
    namespace = "monitoring"

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    tls {
      hosts       = ["prometheus.apps.shaker242.lab"]
      secret_name = "prometheus-secret"
    }

    rule {
      host = "prometheus.example.com"

      http {
        path {
          backend {
            service_name = "prometheus-service"
            service_port = "8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "prometheus_secret" {
  metadata {
    name      = "prometheus-secret"
    namespace = "monitoring"
  }

  data = {
    "tls.crt" = "-----BEGIN CERTIFICATE-----\nMIIFiTCCBHGgAwIBAgIBATANBgkqhkiG9w0BAQsFADCBwDEjMCEGA1UEAxMaaW50\nZXJtZWRpYXRlLnNoYWtlcjI0Mi5sYWIxCzAJBgNVBAYTAlVTMREwDwYDVQQIEwhW\naXJnaW5pYTEQMA4GA1UEBxMHQnJpc3RvdzEsMCoGA1UEChMjU0hBS0VSMjQyIExh\nYiBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxOTA3BgNVBAsTMFNIQUtFUjI0MiBMYWIg\nSW50ZXJtZWRpYXRlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0xOTEwMTcxNjE2\nMzFaFw0yMTEwMTYxNjE2MzFaMIGAMR0wGwYDVQQDFBQqLmFwcHMuc2hha2VyMjQy\nLmxhYjELMAkGA1UEBhMCVVMxETAPBgNVBAgTCFZpcmdpbmlhMRAwDgYDVQQHEwdC\ncmlzdG93MRYwFAYDVQQKEw1TSEFLRVIyNDIgTGFiMRUwEwYDVQQLEwxMYWIgV2Vi\nc2l0ZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDlFmzAWtSOIqvM\nJBWunsEHRlkiz3RjR+Ju55t+HBPoybvpVBIys1gzko/H6Y1kfqkRBS6YaQG3iXDW\nh836SVszMUCUKpm5yYArQ70xbZOMtIr75TG+z1ZDbZxU3nxzEwGt3wSw99Rtn8Vn\n9tJSUr40pGS+Mzc3rvNPVQ22ha9aA7F/cUplmeJdRvDVrwCMvRIDrwWTFcfE7mKq\n1RRDqT8DNyrvRfyIno+fJE1NdnTELcGSaVej8YUQN4v4XTg/2grlH7ZEOUW7/hbo\nQxz5Yez5Rjmp9eOUJouWfZNE4BAldYyV1wcOExQNk0rNA9N9epc5kTUVPGzNMdnr\n/Ut19c0xAgMBAAGjggHKMIIBxjAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIG\nQDALBgNVHQ8EBAMCBaAwMwYJYIZIAYb4QgENBCYWJE9wZW5TU0wgR2VuZXJhdGVk\nIFNlcnZlciBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUdac/x14zuywEVOJ/oN7PyO6l\nCgcwgdsGA1UdIwSB0zCB0IAUsdS5YlnXJVNNfEZdLD//dr4NfWqhgbSkgbEwga4x\nGTAXBgNVBAMTEGNhLnNoYWtlcjI0Mi5sYWIxCzAJBgNVBAYTAlVTMREwDwYDVQQI\nEwhWaXJnaW5pYTEQMA4GA1UEBxMHQnJpc3RvdzEsMCoGA1UEChMjU0hBS0VSMjQy\nIExhYiBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxMTAvBgNVBAsTKFNIQUtFUjI0MiBM\nYWIgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHmCAQEwHQYDVR0lBBYwFAYIKwYB\nBQUHAwEGCCsGAQUFCAICMEgGA1UdEQRBMD+CDXNoYWtlcjI0Mi5sYWKCEmFwcHMu\nc2hha2VyMjQyLmxhYoIUKi5hcHBzLnNoYWtlcjI0Mi5sYWKHBMCoCxAwDQYJKoZI\nhvcNAQELBQADggEBAG07dqMtVXuT+rGnBSxJES63RkjGigtsvm5985++n6cEndH2\nohchgfEJ9WE1aAVH4xBRRuTHPUI8W/wsu8PqCZ84zQCe6zP2y8Dra0n1s+iHxqpD\n+Kppe/u6CKU1D/EVEOLjJYwzQbQKIIO/f5CBUmJFZ0ngUHPKoP3rMz+u9A9aoFEk\nqwt0ZtqGqjc2HwCOT99NValgoHIyc8IqArWv3RZIkiIriodIGC1/x1T6txJpE2F+\nC6tO94SAUIBpseNF3ElcK5K2Mn8aP3Gsg4TGxIO7d5yB/ov04hNWd5Kd0Xj+/PoB\nK9N7pT5IU6r+KzChxiRvdofP3WEX7Vd4KKXox+E=\n-----END CERTIFICATE-----\n"

    "tls.key" = "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDlFmzAWtSOIqvM\nJBWunsEHRlkiz3RjR+Ju55t+HBPoybvpVBIys1gzko/H6Y1kfqkRBS6YaQG3iXDW\nh836SVszMUCUKpm5yYArQ70xbZOMtIr75TG+z1ZDbZxU3nxzEwGt3wSw99Rtn8Vn\n9tJSUr40pGS+Mzc3rvNPVQ22ha9aA7F/cUplmeJdRvDVrwCMvRIDrwWTFcfE7mKq\n1RRDqT8DNyrvRfyIno+fJE1NdnTELcGSaVej8YUQN4v4XTg/2grlH7ZEOUW7/hbo\nQxz5Yez5Rjmp9eOUJouWfZNE4BAldYyV1wcOExQNk0rNA9N9epc5kTUVPGzNMdnr\n/Ut19c0xAgMBAAECggEBANs8tcD0bBzGg4EvO2zM01Bh+6X7wZfN0J5wmnd66XbL\nsUDgSzYoOo3Igj9AfScirCv0uJ31SEZcixdUCkSv9U6toO7rQgjyFO3SuvnVsvJi\nSew9cHj6NcT73jO+ZH1AQEgkeXnfA3YSBDq1lJxiQVNhzGPV4c8xZ/qRHDmEAMdz\nl2i0ztrmqdjJx8i419zF/ZUzKhkbmqVUorcgYMtKyAYhHCLbk6DVmCQal9gtE+65\nNaS8L1QorUcUKAhI3JOd6M4pmdOhLHN6igEpXWUXlAf4HMFbpwy3Z1z3jg5jLOkj\nzIcCITZj/BaVoIW8C2ToJbyBJZCzP5cQRSvBN8exiAECgYEA/WCqolUQkNBD+JyO\nIW9BHEYOKz1DVq5lGDXh4S2M+i9MirNgRW//CEDhQQULfkAL810DOBll1tQEJF+w\noUzukzSYd+XSJxbq39a1udbeu3YSYcx/0LA0xaP9ml7Yu5u+iFx4hprv2/e+VIYA\nsMexZFR807Cs9asy2GEOYvhGJoECgYEA53VmpxYPl1Na5S0IIlJnbn4u9tDzpbnS\nzl20UCt4wCxI4zb65KZ8WUZbQsU5ZgEjNlIYDWR++wy0UxvJcqPngKLn8GhK8o9Q\nyRnGgRap1ZcnPGllgBxt33K9L3V2bs1pOpbJ0ii9WrIc81MpQQiB6uD4Rgmz3FVI\ngRNDsfGKLrECgYEAmf9etjstTlbGeRvt5rRPxndttSoO+2gTWZumJc4hmQ2WX9aV\n9J4VS1bjkTkXuywCF2+4vSfylZdWzSS7nc28UwvsfzLXf5qWNmWxHbpStW0VzwsT\nxCrUaCs7v89VuvD15LsPJgCVOARjUcwAL3Gvh2MyWxdOiCH9TTXwIIb1XAECgYA3\nxeJmgLphDITqlF9RZenmhiFq+A698HkLoSjB6LfAFuu5VJZAYp20JW/4Nu4N1lhV\nzpJdJ8oxVG5fWGLCbRxrstWQ6JCmwkIFM2DR2lQyU6nwtLTwmekf3tYXiYZwTK7+\nnzcinQ6DvEedmnxmX1Zu8qbguZXNkf9Wmv3E8x8JAQKBgQCMx1V4rHqJpUrLvDUU\n8G8WTckOeE3j6jxeps0rq1tGupOWYnlhYMc+yVC306TsgWRbyGV8acZFAxY/Tocy\nliqyTKSF5IhaxYAZQO5d9MhNctm4Qx3Z9KSzFydm5BVU/H+0QfRtp3oSxUgytY5y\nWvCLVyncFfVi/Edi7Zds6io6AQ==\n-----END PRIVATE KEY-----\n"
  }
}

resource "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-service"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9090"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 8080
      target_port = "9090"
      node_port   = 30000
    }

    selector = {
      app = "prometheus-server"
    }

    type = "LoadBalancer"
  }
}