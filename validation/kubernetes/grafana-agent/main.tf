terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-agent"

  cluster_name    = "aks1"
  environment     = "dev"
  cloud_provider  = "azure"
  remote_logs_url = "http://unbox-loki-distributed-distributor.monitor.svc.cluster.local:3100/loki/api/v1/push"
}
