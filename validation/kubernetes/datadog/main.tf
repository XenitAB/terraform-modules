terraform {}

provider "kubernetes" {}

provider "helm" {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  api_key           = "key"    #tfsec:ignore:general-secrets-no-plaintext-exposure
  app_key           = "appkey" #tfsec:ignore:general-secrets-no-plaintext-exposure
  location          = "foo"
  environment       = "bar"
  namespace_include = ["ns1", "ns2"]
  cluster_id        = "foobar"
}
