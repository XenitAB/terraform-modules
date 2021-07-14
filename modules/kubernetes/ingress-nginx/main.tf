/**
  * # Ingress NGINX (ingress-nginx)
  *
  * This module is used to add [`ingress-nginx`](https://github.com/kubernetes/ingress-nginx) to Kubernetes clusters.
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
      name                = join("-", compact(["ingress-nginx", var.name_override]))
      "xkf.xenit.io/kind" = "platform"
    }
    name = join("-", compact(["ingress-nginx", var.name_override]))
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
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name" = "ingress-nginx"
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

resource "kubernetes_network_policy" "allow_ingress_traffic" {
  metadata {
    name      = "allow-ingress-traffic"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name" = "ingress-nginx"
      }
    }

    policy_types = ["Ingress"]

    ingress {
      from {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }

      ports {
        port = "443"
        protocol = "TCP"
      }

      ports {
        port = "80"
        protocol = "TCP"
      }
    }
  }
}

resource "helm_release" "ingress_nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "3.34.0"
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    http_snippet           = var.http_snippet,
    name_override          = var.name_override,
    provider               = var.cloud_provider,
    ingress_class          = join("-", compact(["nginx", var.name_override])),
    internal_load_balancer = var.internal_load_balancer,
    linkerd_enabled        = var.linkerd_enabled
  })]
}
