terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana-k8s-monitoring" {
  source              = "../../../modules/kubernetes/grafana-k8s-monitoring"
  cluster_id          = "yabadabadoo"
  cluster_name        = "foobar123"
  key_vault_id        = "secretstuff"
  resource_group_name = "foo"
  location            = "narnia"
  oidc_issuer_url     = "gimme safe auth"
  grafana_k8s_monitor_config = {
    grafana_cloud_prometheus_host     = "barfoo"
    grafana_cloud_loki_host           = "foobar"
    grafana_cloud_tempo_host          = "bar123"

  }
}
