terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

resource "helm_release" "this" {
  repository  = "https://helm.cilium.io/"
  chart       = "cilium"
  name        = "cilium"
  namespace   = "kube-system"
  version     = "1.12.2"
  max_history = 3

  values = [
    templatefile("${path.module}/templates/values.yaml.tpl", {}),
  ]
}
