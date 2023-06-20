terraform {}

provider "kubernetes" {}

provider "helm" {}

module "spegel" {
  source     = "../../../modules/kubernetes/spegel"
  cluster_id = "foobar"
}
