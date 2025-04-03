locals {
  exclude_namespaces = [
    "aad-pod-identity",
    "azure-metrics",
    "azureserviceoperator-system",
    "calico-system",
    "cert-manager",
    "controle-plane-logs",
    "datadog",
    "external-dns",
    "falco",
    "flux-system",
    "ingress-nginx",
    "linkerd",
    "linkerd-cni",
    "reloader",
    "trivy",
    "tigera-operator",
    "velero",
    "grafana-agent",
    "promtail",
    "prometheus",
    "node-ttl",
    "spegel",
    "vpa",
  ]
  cluster_id = "${var.location_short}-${var.environment}-${var.name}${local.aks_name_suffix}"
  dns_zones = {
    for zone in data.azurerm_dns_zone.this :
    zone.name => zone.id
  }
  aad_groups_view = [
    for key, group in var.aad_groups.view :
    {
      namespace = key
      id        = group.id
      name      = group.name
    }
  ]
}