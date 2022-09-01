terraform {}

module "helm_crd" {
  source = "../../../modules/kubernetes/helm-crd-oci"

  chart         = "oci://ghcr.io/example/helm-charts/example"
  chart_name    = "bar"
  chart_version = "baz"
}
