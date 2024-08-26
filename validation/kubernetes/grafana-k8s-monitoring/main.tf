terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana-k8s-monitoring" {
  source     = "../../../modules/kubernetes/grafana-k8s-monitoring"
  cluster_id = "yabadabadoo"
  grafana_k8s_monitor_config = {
    grafana_cloud_api_key             = "foo"
    grafana_cloud_prometheus_username = "bar"
    grafana_cloud_prometheus_host     = "barfoo"
    grafana_cloud_loki_host           = "foobar"
    grafana_cloud_loki_username       = "foo123"
    grafana_cloud_tempo_host          = "bar123"
    grafana_cloud_tempo_username      = "barfoo123"
    cluster_name                      = "foobar123"
  }
}
