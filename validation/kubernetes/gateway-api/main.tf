terraform {}

provider "kubernetes" {}

provider "helm" {}

module "gateway_api" {
  source     = "../../../modules/kubernetes/gateway-api"
  cluster_id = "foo"
  gateway_api_config = {
    api_version = "v1.1.0"
    api_channel = "experimental"
  }
  tenant_name = "foo"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}