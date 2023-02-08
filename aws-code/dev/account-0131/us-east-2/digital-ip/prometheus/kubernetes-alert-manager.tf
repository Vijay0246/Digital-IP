resource "kubernetes_config_map" "alertmanager_config" {
  metadata {
    name      = "alertmanager-config"
    namespace = "monitoring"
  }

  data = {
    "config.yml" = "global:\ntemplates:\n- '/etc/alertmanager/*.tmpl'\nroute:\n  receiver: alert-emailer\n  group_by: ['alertname', 'priority']\n  group_wait: 10s\n  repeat_interval: 30m\n  routes:\n    - receiver: slack_demo\n    # Send severity=slack alerts to slack.\n      match:\n        severity: slack\n      group_wait: 10s\n      repeat_interval: 1m\n\nreceivers:\n- name: alert-emailer\n  email_configs:\n  - to: demo@devopscube.com\n    send_resolved: false\n    from: from-email@email.com\n    smarthost: smtp.eample.com:25\n    require_tls: false\n- name: slack_demo\n  slack_configs:\n  - api_url: https://hooks.slack.com/services/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sz4Qk\n    channel: '#devopscube-demo'"
  }
}

resource "kubernetes_config_map" "alertmanager_templates" {
  metadata {
    name      = "alertmanager-templates"
    namespace = "monitoring"
  }

  data = {
    "default.tmpl" = "{{ define \"__alertmanager\" }}AlertManager{{ end }}\n{{ define \"__alertmanagerURL\" }}{{ .ExternalURL }}/#/alerts?receiver={{ .Receiver }}{{ end }}\n{{ define \"__subject\" }}[{{ .Status | toUpper }}{{ if eq .Status \"firing\" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .GroupLabels.SortedPairs.Values | join \" \" }} {{ if gt (len .CommonLabels) (len .GroupLabels) }}({{ with .CommonLabels.Remove .GroupLabels.Names }}{{ .Values | join \" \" }}{{ end }}){{ end }}{{ end }}\n{{ define \"__description\" }}{{ end }}\n{{ define \"__text_alert_list\" }}{{ range . }}Labels:\n{{ range .Labels.SortedPairs }} - {{ .Name }} = {{ .Value }}\n{{ end }}Annotations:\n{{ range .Annotations.SortedPairs }} - {{ .Name }} = {{ .Value }}\n{{ end }}Source: {{ .GeneratorURL }}\n{{ end }}{{ end }}\n{{ define \"slack.default.title\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"slack.default.username\" }}{{ template \"__alertmanager\" . }}{{ end }}\n{{ define \"slack.default.fallback\" }}{{ template \"slack.default.title\" . }} | {{ template \"slack.default.titlelink\" . }}{{ end }}\n{{ define \"slack.default.pretext\" }}{{ end }}\n{{ define \"slack.default.titlelink\" }}{{ template \"__alertmanagerURL\" . }}{{ end }}\n{{ define \"slack.default.iconemoji\" }}{{ end }}\n{{ define \"slack.default.iconurl\" }}{{ end }}\n{{ define \"slack.default.text\" }}{{ end }}\n{{ define \"hipchat.default.from\" }}{{ template \"__alertmanager\" . }}{{ end }}\n{{ define \"hipchat.default.message\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"pagerduty.default.description\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"pagerduty.default.client\" }}{{ template \"__alertmanager\" . }}{{ end }}\n{{ define \"pagerduty.default.clientURL\" }}{{ template \"__alertmanagerURL\" . }}{{ end }}\n{{ define \"pagerduty.default.instances\" }}{{ template \"__text_alert_list\" . }}{{ end }}\n{{ define \"opsgenie.default.message\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"opsgenie.default.description\" }}{{ .CommonAnnotations.SortedPairs.Values | join \" \" }}\n{{ if gt (len .Alerts.Firing) 0 -}}\nAlerts Firing:\n{{ template \"__text_alert_list\" .Alerts.Firing }}\n{{- end }}\n{{ if gt (len .Alerts.Resolved) 0 -}}\nAlerts Resolved:\n{{ template \"__text_alert_list\" .Alerts.Resolved }}\n{{- end }}\n{{- end }}\n{{ define \"opsgenie.default.source\" }}{{ template \"__alertmanagerURL\" . }}{{ end }}\n{{ define \"victorops.default.message\" }}{{ template \"__subject\" . }} | {{ template \"__alertmanagerURL\" . }}{{ end }}\n{{ define \"victorops.default.from\" }}{{ template \"__alertmanager\" . }}{{ end }}\n{{ define \"email.default.subject\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"email.default.html\" }}\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<!--\nStyle and HTML derived from https://github.com/mailgun/transactional-email-templates\nThe MIT License (MIT)\nCopyright (c) 2014 Mailgun\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n-->\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns=\"http://www.w3.org/1999/xhtml\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n<head style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n<meta name=\"viewport\" content=\"width=device-width\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n<title style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">{{ template \"__subject\" . }}</title>\n</head>\n<body itemscope=\"\" itemtype=\"http://schema.org/EmailMessage\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; height: 100%; line-height: 1.6em; width: 100% !important; background-color: #f6f6f6; margin: 0; padding: 0;\" bgcolor=\"#f6f6f6\">\n<table style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\">\n  <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n    <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td>\n    <td width=\"600\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; width: 100% !important; margin: 0 auto; padding: 0;\" valign=\"top\">\n      <div style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 0;\">\n        <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; border: 1px solid #e9e9e9;\" bgcolor=\"#fff\">\n          <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n            <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 16px; vertical-align: top; color: #fff; font-weight: 500; text-align: center; border-radius: 3px 3px 0 0; background-color: #E6522C; margin: 0; padding: 20px;\" align=\"center\" bgcolor=\"#E6522C\" valign=\"top\">\n              {{ .Alerts | len }} alert{{ if gt (len .Alerts) 1 }}s{{ end }} for {{ range .GroupLabels.SortedPairs }}\n                {{ .Name }}={{ .Value }}\n              {{ end }}\n            </td>\n          </tr>\n          <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n            <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 10px;\" valign=\"top\">\n              <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <a href=\"{{ template \"__alertmanagerURL\" . }}\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2em; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #348eda; margin: 0; border-color: #348eda; border-style: solid; border-width: 10px 20px;\">View in {{ template \"__alertmanager\" . }}</a>\n                  </td>\n                </tr>\n                {{ if gt (len .Alerts.Firing) 0 }}\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">[{{ .Alerts.Firing | len }}] Firing</strong>\n                  </td>\n                </tr>\n                {{ end }}\n                {{ range .Alerts.Firing }}\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">Labels</strong><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                    {{ range .Labels.SortedPairs }}{{ .Name }} = {{ .Value }}<br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    {{ if gt (len .Annotations) 0 }}<strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">Annotations</strong><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    {{ range .Annotations.SortedPairs }}{{ .Name }} = {{ .Value }}<br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    <a href=\"{{ .GeneratorURL }}\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; color: #348eda; text-decoration: underline; margin: 0;\">Source</a><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                  </td>\n                </tr>\n                {{ end }}\n                {{ if gt (len .Alerts.Resolved) 0 }}\n                  {{ if gt (len .Alerts.Firing) 0 }}\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                    <hr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                    <br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                  </td>\n                </tr>\n                  {{ end }}\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">[{{ .Alerts.Resolved | len }}] Resolved</strong>\n                  </td>\n                </tr>\n                {{ end }}\n                {{ range .Alerts.Resolved }}\n                <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n                  <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\">\n                    <strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">Labels</strong><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                    {{ range .Labels.SortedPairs }}{{ .Name }} = {{ .Value }}<br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    {{ if gt (len .Annotations) 0 }}<strong style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">Annotations</strong><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    {{ range .Annotations.SortedPairs }}{{ .Name }} = {{ .Value }}<br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />{{ end }}\n                    <a href=\"{{ .GeneratorURL }}\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; color: #348eda; text-decoration: underline; margin: 0;\">Source</a><br style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />\n                  </td>\n                </tr>\n                {{ end }}\n              </table>\n            </td>\n          </tr>\n        </table>\n        <div style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; clear: both; color: #999; margin: 0; padding: 20px;\">\n          <table width=\"100%\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n            <tr style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\">\n              <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 12px; vertical-align: top; text-align: center; color: #999; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"><a href=\"{{ .ExternalURL }}\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 12px; color: #999; text-decoration: underline; margin: 0;\">Sent by {{ template \"__alertmanager\" . }}</a></td>\n            </tr>\n          </table>\n        </div></div>\n    </td>\n    <td style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td>\n  </tr>\n</table>\n</body>\n</html>\n{{ end }}\n{{ define \"pushover.default.title\" }}{{ template \"__subject\" . }}{{ end }}\n{{ define \"pushover.default.message\" }}{{ .CommonAnnotations.SortedPairs.Values | join \" \" }}\n{{ if gt (len .Alerts.Firing) 0 }}\nAlerts Firing:\n{{ template \"__text_alert_list\" .Alerts.Firing }}\n{{ end }}\n{{ if gt (len .Alerts.Resolved) 0 }}\nAlerts Resolved:\n{{ template \"__text_alert_list\" .Alerts.Resolved }}\n{{ end }}\n{{ end }}\n{{ define \"pushover.default.url\" }}{{ template \"__alertmanagerURL\" . }}{{ end }}\n"

    "slack.tmpl" = "{{ define \"slack.devops.text\" }}\n{{range .Alerts}}{{.Annotations.DESCRIPTION}}\n{{end}}\n{{ end }}\n"
  }
}

resource "kubernetes_deployment" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = "monitoring"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "alertmanager"
      }
    }

    template {
      metadata {
        name = "alertmanager"

        labels = {
          app = "alertmanager"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "alertmanager-config"
          }
        }

        volume {
          name = "templates-volume"

          config_map {
            name = "alertmanager-templates"
          }
        }

        volume {
          name = "alertmanager"
        }

        container {
          name  = "alertmanager"
          image = "prom/alertmanager:v0.19.0"
          args  = ["--config.file=/etc/alertmanager/config.yml", "--storage.path=/alertmanager"]

          port {
            name           = "alertmanager"
            container_port = 9093
          }

          resources {
            limits {
              memory = "1Gi"
              cpu    = "1"
            }

            requests {
              memory = "500M"
              cpu    = "500m"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/alertmanager"
          }

          volume_mount {
            name       = "templates-volume"
            mount_path = "/etc/alertmanager-templates"
          }

          volume_mount {
            name       = "alertmanager"
            mount_path = "/alertmanager"
          }
        }
      }
    }
  }
  wait_for_rollout = false
}

resource "kubernetes_service" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9093"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 9093
      target_port = "9093"
      node_port   = 31000
    }

    selector = {
      app = "alertmanager"
    }

    type = "LoadBalancer"
  }
}