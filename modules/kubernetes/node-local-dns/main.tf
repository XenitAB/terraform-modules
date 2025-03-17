/**
  * # node local DNS
  *
  * This module is used to add [`node-local-dns`](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/) to Kubernetes clusters.
  */

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.3"
    }
  }
}

resource "git_repository_file" "node_local_dns" {
  path = "platform/${var.cluster_id}/node-local-dns/node-local-dns.yaml"
  content = templatefile("${path.module}/templates/node-local-dns.yaml.tpl", {
    local_dns        = "169.254.20.10"
    dns_ip           = var.dns_ip
    coredns_upstream = var.coredns_upstream
    cilium_enabled   = var.cilium_enabled
  })
}
