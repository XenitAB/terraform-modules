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
  dns_zones = var.external_dns_config.rbac_create ? {
    for zone in data.azurerm_dns_zone.this :
    zone.name => zone.id
    } : {
    for zone in var.dns_zones :
    zone => zone
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