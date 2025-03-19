terraform {}

provider "kubernetes" {}

provider "helm" {}

module "ingress_nginx" {
  source = "../../../modules/kubernetes/ingress-nginx"

  aad_groups = {
    view = null
    edit = {
      "id-1" : "name-1"
    }
    cluster_admin        = null
    cluster_view         = null
    aks_managed_identity = null
  }
  cluster_id = "bar"
  namespaces = [
    {
      name = "namespace-1"
      labels = {
        "terraform" = "true"
      }
    }
  ]
  replicas                            = 3
  min_replicas                        = 2
  nginx_healthz_ingress_hostname      = "yabadabadee.com"
  nginx_healthz_ingress_whitelist_ips = "a string"
  tenant_name                         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
