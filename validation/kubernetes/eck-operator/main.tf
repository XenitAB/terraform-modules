terraform {}

provider "kubernetes" {}

provider "helm" {}

module "eck-operator" {
  source                 = "../../../modules/kubernetes/eck-operator"
  cluster_id             = "yabadabadoo"
  eck_managed_namespaces = []
  tenant_name            = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
