/**
  * # Goldpinger
  *
  * Adds [`Goldpinger`](https://github.com/bloomberg/goldpinger) to a Kubernetes clusters.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name                = "goldpinger"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "goldpinger"
  }
}

resource "kubernetes_network_policy" "deny_default" {
  metadata {
    name      = "deny-default"
    namespace = kubernetes_namespace.this.metadata[0].name
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

# Official Helm repo is deprecated to using fork.
# https://github.com/bloomberg/goldpinger/issues/93
resource "helm_release" "goldpinger" {
  repository = "https://okgolove.github.io/helm-charts/"
  chart      = "goldpinger"
  name       = "goldpinger"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "4.1.1"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    linkerd_enabled = var.linkerd_enabled
  })]
}
