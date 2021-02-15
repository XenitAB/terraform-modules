terraform {}

provider "kubernetes" {}

provider "helm" {}

module "falco" {
  source = "../../../modules/kubernetes/falco"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }

  environment = "dev"
  datadog_api_key = "foobar" #tfsec:ignore:GEN003
}
