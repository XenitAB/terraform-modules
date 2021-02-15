terraform {}

provider "kubernetes" {}

provider "helm" {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  api_key = "key" #tfsec:ignore:GEN003
  location = "foo"
  environment = "bar"
}
