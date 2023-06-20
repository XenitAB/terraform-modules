terraform {}

provider "kubernetes" {}

provider "helm" {}

module "node_local_dns" {
  source     = "../../../modules/kubernetes/node-local-dns"
  cluster_id = "foobar"
  dns_ip     = "10.0.0.0"
}
