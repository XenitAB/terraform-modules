terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana-k8s-monitoring-billable" {
  source               = "../../../modules/kubernetes/grafana-k8s-monitoring-billable"
  cluster_id           = "yabadabadoo"
  cluster_name         = "foobar123"
  azure_key_vault_name = "boobooyaba"
  key_vault_id         = "secretstuff"
  resource_group_name  = "foo"
  location             = "narnia"
  oidc_issuer_url      = "gimme safe auth"
  tenant_name          = "foo"
  environment          = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
