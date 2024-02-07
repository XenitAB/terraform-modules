terraform {}

provider "kubernetes" {}

provider "helm" {}

module "ingress_nginx" {
  source     = "../../../modules/kubernetes/ingress-nginx"
  cluster_id = "bar"
}
