terraform {}

provider "kubernetes" {}

provider "helm" {}

module "spegel" {
  source      = "../../../modules/kubernetes/spegel"
  cluster_id  = "foobar"
  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
