terraform {}

provider "kubernetes" {}

provider "helm" {}

module "datadog" {
  source = "../../../modules/kubernetes/datadog"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  api_key           = "key"    #tfsec:ignore:GEN003
  app_key           = "appkey" #tfsec:ignore:GEN003
  location          = "foo"
  environment       = "bar"
  container_include = "kube_namespace:.*."
}
