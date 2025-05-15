terraform {}

provider "kubernetes" {}

provider "helm" {}

module "grafana_alloy" {
  source = "../../../modules/kubernetes/grafana-alloy"

  cluster_id          = "foo"
  oidc_issuer_url     = "url"
  resource_group_name = "rg-name"
  environment         = "dev"
  aks_name            = "fooburrito"
  location_short      = "foob"
  grafana_alloy_config = {
    cluster_name                        = "awesome_cluster"
    azure_key_vault_name                = "foobar"
    keyvault_secret_name                = "barfoo"
    grafana_otelcol_auth_basic_username = "some-integers"
    grafana_otelcol_exporter_endpoint   = "some-url"
  }
  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
