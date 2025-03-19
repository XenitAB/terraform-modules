terraform {}

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  aad_groups = {
    view = null
    edit = {
      "id-1" : "name-1"
    }
    cluster_admin        = null
    cluster_view         = null
    aks_managed_identity = null
  }
  cluster_id   = "foo"
  dns_provider = "azure"
  dns_zones = {
    "a.com" = "id"
  }
  environment                = "dev"
  global_resource_group_name = "global"
  location                   = "location"
  location_short             = "we"
  namespaces = [
    {
      name = "namespace-1"
      labels = {
        "terraform" = "true"
      }
    }
  ]
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  subscription_id     = "id"
  txt_owner_id        = "dev-aks1"
  sources             = ["ingress", "service"]
  extra_args          = []
  tenant_name         = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
