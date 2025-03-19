terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  aad_groups = {
    view = null
    edit = {
      "id-1" : "name-1"
    }
    cluster_admin        = null
    cluster_view         = null
    aks_managed_identity = null
  }
  cluster_id = "foobar"
  dns_zones = {
    "a.com" = "id"
  }
  global_resource_group_name = "global"
  location                   = "location"
  namespaces = [
    {
      name = "namespace-1"
      labels = {
        "terraform" = "true"
      }
    }
  ]
  notification_email  = "example@example.com"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  subscription_id     = "id"
  gateway_api_enabled = true
  gateway_api_config  = {}
  tenant_name         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
