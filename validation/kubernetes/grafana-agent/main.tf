terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-agent"

  remote_write_urls = {
    metrics = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"
    logs    = "https://logs-prod-eu-west-0.grafana.net/loki/api/v1/push"
  }

  credentials = {
    metrics_username = "foo"
    metrics_password = "bar"
    logs_username    = "foo"
    logs_password    = "bar"
  }

  cluster_name = "aks1"
  environment  = "dev"
}
