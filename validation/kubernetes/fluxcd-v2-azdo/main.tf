terraform {}

module "fluxcd_v2_azdo" {
  source = "../../../modules/kubernetes/fluxcd-v2-azdo"

  azure_devops_pat  = "123456"
  azure_devops_org  = "foo"
  azure_devops_proj = "bar"
  environment       = "dev"
  cluster_id        = "foobar"
  cluster_repo      = "repo"
  namespaces        = []
}
