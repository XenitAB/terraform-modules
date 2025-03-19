terraform {}

provider "kubernetes" {}

provider "helm" {}

module "linkerd" {
  source = "../../../modules/kubernetes/linkerd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  tenant_name = "foo"
  cluster_id  = "aks-unique-name"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
