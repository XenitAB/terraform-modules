terraform {}

provider "kubernetes" {}

provider "helm" {}

module "falco" {
  source = "../../../modules/kubernetes/falco"

  cloud_provider = "bar"
  cluster_id     = "foo"
}
