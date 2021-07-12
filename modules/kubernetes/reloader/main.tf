/**
  * # Reloader
  *
  * Adds [`Reloader`](https://github.com/stakater/Reloader) to a Kubernetes clusters.
  *
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
      name                = "reloader"
      "xkf.xenit.io/kind" = "platform"
    }
    name = "reloader"
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

resource "kubernetes_network_policy" "allow_scraping" {
  metadata {
    name      = "allow-scraping"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "reloader-reloader"
        group = "com.stakater.platform"
        provider = "stakater"
        release = "reloader"
      }
    }

    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "prometheus"
          }
        }
        pod_selector {
          match_labels = {
            app = "prometheus"
            "app.kubernetes.io/name" = "prometheus"
          }
        }
      }

      ports {
        port = "metrics"
        protocol = "TCP"
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_api_server" {
  metadata {
    name      = "allow-api-server"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "reloader-reloader"
        group = "com.stakater.platform"
        provider = "stakater"
        release = "reloader"
      }
    }

    policy_types = ["Egress"]

    egress {
      to {
        ip_block {
          cidr = "10.0.0.1"
        }
      }

      ports {
        port     = 443
        protocol = "TCP"
      }
    }
  }
}

resource "helm_release" "reloader" {
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  name       = "reloader"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.0.96"

  set {
    name  = "reloader.deployment.priorityClassName"
    value = "platform-low"
  }
}
