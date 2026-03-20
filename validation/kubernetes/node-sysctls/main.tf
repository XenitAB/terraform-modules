terraform {
  required_providers {
    git = {
      source  = "xenitab/git"
      version = "0.0.4"
    }
  }
}

provider "git" {}

module "node_sysctls" {
  source = "../../../modules/kubernetes/node-sysctls"

  cluster_id  = "foobar"
  environment = "dev"
  tenant_name = "foo"

  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}