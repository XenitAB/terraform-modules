resource "kubernetes_network_policy" "allow_egress_ingress_datadog" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.datadog_enabled && var.kubernetes_network_policy_default_deny
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

resource "kubernetes_network_policy" "allow_egress_ingress_grafana_agent" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.grafana_agent_enabled && var.kubernetes_network_policy_default_deny
  }

  metadata {
    name      = "allow-ingress-egress-grafana-agent"
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
            "name" = "grafana-agent-traces"
          }
        }
        namespace_selector {
          match_labels = {
            "name" = "grafana-agent"
          }
        }
      }
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "grafana-agent"
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_egress_traffic_manager" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.telepresence_enabled && var.kubernetes_network_policy_default_deny
  }

  metadata {
    name      = "allow-egress-traffic-manager"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name

    labels = {
      "xkf.xenit.io/kind" = "tenant"
    }
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        pod_selector {
          match_labels = {
            "app" = "traffic-manager"
          }
        }
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "ambassador"
          }
        }
      }

      ports {
        port     = "8081"
        protocol = "TCP"
      }
    }
  }
}
