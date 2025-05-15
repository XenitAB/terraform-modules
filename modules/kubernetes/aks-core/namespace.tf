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

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_service_account_v1" "tenant" {
  depends_on = [kubernetes_namespace.tenant]

  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = each.key
    namespace = each.key
    annotations = {
      "azure.workload.identity/client-id" = data.azurerm_user_assigned_identity.tenant[each.key].client_id
    }
  }
}

resource "kubernetes_limit_range" "tenant" {
  depends_on = [kubernetes_namespace.tenant]

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

# Denys all traffic but except to coredns and inside of namespace.
resource "kubernetes_network_policy" "tenant" {
  depends_on = [kubernetes_namespace.tenant]

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
    name      = "xenit-tenant-default-deny"
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

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "grafana-k8s-monitoring"
          }
        }
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
      # TODO: Use output from node-local-dns module
      to {
        ip_block {
          cidr = "10.0.0.10/32"
        }
      }
      # TODO: Use output from node-local-dns module
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
    egress {
      to {
        namespace_selector {
          match_labels = {
            "name" = "linkerd"
          }
        }
      }
    }
  }
}
