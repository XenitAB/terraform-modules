resource "kubernetes_namespace" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    labels = merge(
      { for k, v in each.value.labels : k => v },
      {
        "name"              = each.value.name,
        "xkf.xenit.io/kind" = "tenant"
      }
    )
    name = each.value.name
  }
}

resource "kubernetes_limit_range" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "default"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
  }

  spec {
    limit {
      type = "Container"
      default_request = {
        cpu    = var.kubernetes_default_limit_range.default_request.cpu
        memory = var.kubernetes_default_limit_range.default_request.memory
      }
      default = {
        memory = var.kubernetes_default_limit_range.default.memory
      }
    }
  }
}

# Denys all traffic except traffic within the namespace and to CoreDNS.
resource "kubernetes_network_policy" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.kubernetes_network_policy_default_deny
  }

  metadata {
    labels = merge(
      { for k, v in each.value.labels : k => v },
      { "name" = each.value.name }
    )
    name      = "default-deny"
    namespace = kubernetes_namespace.tenant[each.key].metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {}
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        pod_selector {}
      }
    }

    egress {
      to {
        namespace_selector {}
        pod_selector {
          match_labels = {
            k8s-app = "kube-dns"
          }
        }
      }
      to {
        ip_block {
          cidr = "10.0.0.10/32"
        }
      }
      to {
        ip_block {
          cidr = "169.254.20.10/32"
        }
      }
      ports {
        port     = 53
        protocol = "UDP"
      }
      ports {
        port     = 53
        protocol = "TCP"
      }
    }

    egress {
      to {
        pod_selector {}
      }
    }
  }
}

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
