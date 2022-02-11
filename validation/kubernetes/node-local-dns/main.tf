terraform {}

provider "kubernetes" {}

provider "helm" {}

module "node_local_dns" {
  source = "../../../modules/kubernetes/node-local-dns"
}
