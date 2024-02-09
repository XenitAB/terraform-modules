terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

  cluster_id         = "foobar"
  notification_email = "example@example.com"
}
