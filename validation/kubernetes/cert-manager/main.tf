terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  cluster_id = "foobar"
  dns_zones = {
    "a.com" = "id"
  }
  global_resource_group_name = "global"
  location                   = "location"
  notification_email         = "example@example.com"
  oidc_issuer_url            = "url"
  resource_group_name        = "rg-name"
  subscription_id            = "id"
}
