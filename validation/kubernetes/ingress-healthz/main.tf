terraform {}

provider "kubernetes" {}

provider "helm" {}

module "ingress_healthz" {
  source = "../../../modules/kubernetes/ingress-healthz"

  environment = "dev"
  dns_zone    = "foo.bar.com"
  cluster_id  = "foobar"
}
