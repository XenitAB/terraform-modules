terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana-k8s-monitoring-lite" {
  source              = "../../../modules/kubernetes/grafana-k8s-monitoring"
  cluster_id          = "yabadabadoo"
  cluster_name        = "foobar123"
  key_vault_id        = "secretstuff"
  resource_group_name = "foo"
  location            = "narnia"
  oidc_issuer_url     = "gimme safe auth"
  grafana_k8s_monitor_config = {
    grafana_cloud_prometheus_host = "barfoo"
    grafana_cloud_loki_host       = "foobar"
    grafana_cloud_tempo_host      = "bar123"
    azure_key_vault_name          = "boobooyaba"
    include_namespaces            = "one,two,three"
    exclude_namespaces            = ["threetwoone"]
  }
  tenant_name = "foo"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
  subscription_id = "subscription-id"
}
