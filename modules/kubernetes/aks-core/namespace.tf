resource "kubernetes_namespace" "service_accounts" {
  metadata {
    labels = {
      name = local.service_accounts_namespace
    }
    name = local.service_accounts_namespace
  }
}

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

resource "kubernetes_service_account" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = each.value.name
    namespace = kubernetes_namespace.service_accounts.metadata[0].name
  }
}

resource "kubernetes_limit_range" "tenant" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "default"
    namespace = each.key
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
    name      = "deny-default"
    namespace = each.value.name
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

      ports {
        port     = 53
        protocol = "UDP"
      }
    }

    egress {
      to {
        pod_selector {}
      }
    }
  }
}
