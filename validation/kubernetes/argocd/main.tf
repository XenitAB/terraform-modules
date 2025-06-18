terraform {}

module "argocd" {
  source = "../../../modules/kubernetes/argocd"

  aks_cluster_id = "/subscriptions/...."
  argocd_config = {
    global_domain        = "example.com"
    ingress_whitelist_ip = "10.0.2.0"
    tenant               = "example.onmicrosoft.com"
    oidc_issuer_url = {
      env = "https://issuer-url"
    }
  }
  cluster_id               = "cluster-id"
  environment              = "dev"
  resource_group_name      = "rg_name"
  location                 = "location"
  core_resource_group_name = "rg-core"
  key_vault_name           = "my-keyvault"
  fleet_infra_config = {
    git_repo_url        = "https://some-git-repo.git"
    argocd_project_name = "default"
    k8s_api_server_url  = "https://kubernetes.default.svc"
  }
  tenant_name = "acme"
}
