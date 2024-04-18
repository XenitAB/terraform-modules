terraform {}

provider "kubernetes" {}

provider "helm" {}

module "control-plane-logs" {
  source = "../../../modules/kubernetes/control-plane-logs"

  cluster_id = "id"
}
