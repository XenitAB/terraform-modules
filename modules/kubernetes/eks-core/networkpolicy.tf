resource "kubernetes_network_policy" "allow_datadog" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if var.datadog_enabled
  }

  metadata {
    name      = "allow-egress-datadog-tracing"
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
            "app.kubernetes.io/instance" = "agent"
            "app.kubernetes.io/name"     = "datadog-agent-deployment"
          }
        }
      }

      ports {
        port     = "8126"
        protocol = "TCP"
      }
    }
  }
}
