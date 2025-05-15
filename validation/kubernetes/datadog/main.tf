terraform {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  apm_ignore_resources = ["foo"]
  cluster_id           = "foo"
  environment          = "dev"
  key_vault_id         = "id"
  location             = "location"
  location_short       = "we"
  namespace_include    = ["ns1", "ns2"]
  oidc_issuer_url      = "url"
  resource_group_name  = "rg-name"
  tenant_name          = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
