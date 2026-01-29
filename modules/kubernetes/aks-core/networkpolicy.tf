resource "kubernetes_network_policy" "allow_egress_ingress_datadog" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.platform_config.datadog_enabled && var.kubernetes_network_policy_default_deny
  }

  metadata {
    name      = "allow-ingress-egress-datadog-tracing"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  spec {
    pod_selector {}
    policy_types = ["Egress", "Ingress"]

    egress {
      to {
        pod_selector {
          match_labels = {
            "app.kubernetes.io/instance" = "agent"
            "app.kubernetes.io/name"     = "datadog-agent-deployment"
          }
        }
        namespace_selector {
          match_labels = {
            "name" = "datadog"
          }
        }
      }

      ports {
        port     = "8126"
        protocol = "TCP"
      }
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "datadog"
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_egress_ingress_grafana_alloy" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if(var.platform_config.grafana_alloy_enabled || var.platform_config.grafana_alloy_enabled) && var.kubernetes_network_policy_default_deny
  }

  metadata {
    name      = "allow-ingress-egress-grafana-alloy"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  spec {
    pod_selector {}
    policy_types = ["Egress", "Ingress"]

    egress {
      to {
        pod_selector {}
        namespace_selector {
          match_labels = {
            "name" = "grafana-alloy"
          }
        }
      }
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "grafana-alloy"
          }
        }
      }
    }
  }
}
