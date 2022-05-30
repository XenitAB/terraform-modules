terraform {}

module "helm_crd" {
  source = "../../../modules/kubernetes/helm-crd"

  chart_repository = "foo"
  chart_name       = "bar"
  chart_version    = "baz"
}
