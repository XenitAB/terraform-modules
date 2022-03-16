terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-agent-tenant"

  remote_write_urls = {
    metrics = "foo"
    logs    = "bar"
    traces  = "baz"
  }

  credentials = {
    metrics_username = "foo"
    metrics_password = "bar"
    logs_username    = "foo"
    logs_password    = "bar"
    traces_username  = "foo"
    traces_password  = "bar"
  }

  cluster_name      = "aks1"
  environment       = "dev"
  vpa_enabled       = false
  namespace_include = ["foobar"]
}
