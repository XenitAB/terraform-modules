terraform {}

provider "kubernetes" {}

provider "helm" {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  location             = "foo"
  environment          = "bar"
  namespace_include    = ["ns1", "ns2"]
  cluster_id           = "foobar"
  apm_ignore_resources = ["foo"]
}
