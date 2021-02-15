terraform {}

provider "azurerm" {
  features {}
}

provider "kubernetes" {}


provider "helm" {}

module "loki" {
  source = "../../../modules/kubernetes/loki"

  providers = {
    azurerm = azurerm
    kubernetes = kubernetes
    helm    = helm
  }

  environment    = "dev"
  location_short = "we"
  name           = "xks"
}
