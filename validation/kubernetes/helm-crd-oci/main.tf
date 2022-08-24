terraform {}

module "helm_crd" {
  source = "../../../modules/kubernetes/helm-crd-oci"

  chart_name       = "bar"
  chart_version    = "baz"
}
