terraform {}

provider "kubernetes" {}

provider "helm" {}

module "node_ttl" {
  source                      = "../../../modules/kubernetes/node-ttl"
  cluster_id                  = "foobar"
  status_config_map_namespace = "kube-system"
}
