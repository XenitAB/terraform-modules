terraform {}

provider "kubernetes" {}

provider "helm" {}

module "contour" {
  source     = "../../../modules/kubernetes/contour"
  cluster_id = "bar"
}