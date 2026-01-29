terraform {}

provider "kubernetes" {}

provider "git" {

}

module "grafana_agent" {
  source = "../../../modules/kubernetes/grafana-agent"

  cluster_id   = "foo"
  cluster_name = "aks1"
  credentials = {
    metrics_username = "foo"
    metrics_password = "bar"
    logs_username    = "foo"
    logs_password    = "bar"
    traces_username  = "foo"
    traces_password  = "bar"
  }
  environment       = "dev"
  namespace_include = ["foobar"]
  remote_write_urls = {
    metrics = "foo"
    logs    = "bar"
    traces  = "baz"
  }
  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
