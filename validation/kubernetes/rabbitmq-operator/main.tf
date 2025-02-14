terraform {}

provider "kubernetes" {}

provider "helm" {}

module "rabbitmq-operator" {
  source     = "../../../modules/kubernetes/rabbitmq-operator"
  cluster_id = "aks-prod-sdc-aks1"
  rabbitmq_config = {
    min_available          = 1
    replica_count          = 2
    spot_instances_enabled = false
    watch_namespaces       = []
  }
}