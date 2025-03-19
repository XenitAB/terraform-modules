terraform {}

provider "kubernetes" {}

module "litmus" {
  source = "../../../modules/kubernetes/litmus"

  azure_key_vault_name          = "my-key-vault"
  cluster_id                    = "aks1"
  key_vault_resource_group_name = "my-resource-group"
  tenant_name                   = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}