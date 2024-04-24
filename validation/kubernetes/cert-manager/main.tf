terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  notification_email = "example@example.com"
  cluster_id         = "foobar"
}
