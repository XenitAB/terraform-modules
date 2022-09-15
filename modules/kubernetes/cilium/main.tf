terraform {
  required_version = ">= 1.2.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

resource "helm_release" "this" {
  repository  = "https://helm.cilium.io/"
  chart       = "cilium"
  name        = "cilium"
  namespace   = "kube-system"
  version     = "1.12.1"
  max_history = 3

  values = [
    templatefile("${path.module}/templates/values.yaml.tpl", {}),
  ]
}
