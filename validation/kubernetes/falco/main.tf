terraform {}

provider "kubernetes" {}

provider "helm" {}

module "falco" {
  source = "../../../modules/kubernetes/falco"

  cluster_id = "foo"
}
