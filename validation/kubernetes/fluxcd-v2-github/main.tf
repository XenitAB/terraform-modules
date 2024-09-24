terraform {}

module "fluxcd_v2" {
  source = "../../../modules/kubernetes/fluxcd-v2-github"

  github_org             = "foo"
  github_app_id          = 123
  github_installation_id = 123
  github_private_key     = "foo" #tfsec:ignore:general-secrets-no-plaintext-exposure
  environment            = "dev"
  cluster_id             = "foobar"
  cluster_repo           = "repo"
  namespaces             = []
  slack_flux_alert_config = {
    xenit_webhook  = "barfoo"
    tenant_webhook = "barbar"
  }
}
