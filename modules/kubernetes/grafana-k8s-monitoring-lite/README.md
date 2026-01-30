# grafana-k8s-monitoring-lite

Lightweight Kubernetes monitoring that only collects **node CPU capacity** per cluster.

## Purpose

Sends minimal metrics to Grafana Cloud for tracking CPU resources across all clusters:
- `kube_node_status_capacity{resource="cpu"}` - CPU cores per node
- `kube_node_info` - Node metadata

## What's disabled (compared to full grafana-k8s-monitoring)

- ❌ Logs (Loki)
- ❌ Traces (Tempo)
- ❌ Pod metrics
- ❌ Node exporter
- ❌ OpenCost
- ❌ Kepler (energy metrics)
- ❌ Application observability
- ❌ Cluster events

## PromQL Queries

```promql
# Total CPUs per cluster
sum by (cluster) (kube_node_status_capacity{resource="cpu"})

# CPUs per cluster over time
sum by (cluster) (kube_node_status_capacity{resource="cpu"})[30d:1d]

# Number of nodes per cluster
count by (cluster) (kube_node_info)
```

## Requirements

Azure Key Vault must contain:
- `prometheus-grafana-cloud-host`
- `prometheus-grafana-cloud-user`
- `prometheus-grafana-cloud-password`

## Usage

```hcl
module "grafana_k8s_monitoring_lite" {
  source = "../../kubernetes/grafana-k8s-monitoring-lite"

  azure_key_vault_name = "kv-myproject-prod"
  cluster_id           = "we-prod-aks1"
  cluster_name         = "we-prod-aks1"
  environment          = "prod"
  key_vault_id         = data.azurerm_key_vault.core.id
  location             = "westeurope"
  oidc_issuer_url      = module.aks.oidc_issuer_url
  resource_group_name  = "rg-myproject-prod"
  tenant_name          = "myproject"

  fleet_infra_config = {
    argocd_project_name = "platform"
    git_repo_url        = "https://github.com/myorg/argocd-fleet-infra.git"
    k8s_api_server_url  = "https://kubernetes.default.svc"
  }
}
```
