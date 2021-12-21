terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-agent"
}
