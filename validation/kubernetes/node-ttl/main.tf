terraform {}

provider "kubernetes" {}

provider "helm" {}

module "node_ttl" {
  source                      = "../../../modules/kubernetes/node-ttl"
  cluster_id                  = "foobar"
  status_config_map_namespace = "kube-system"
  tenant_name                 = "foo"
  environment                 = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
