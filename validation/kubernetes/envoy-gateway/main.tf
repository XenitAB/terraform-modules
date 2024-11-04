terraform {}

provider "kubernetes" {}

provider "helm" {}

module "envoy-gateway" {
  source = "../../../modules/kubernetes/envoy-gateway"

  cluster_id = "foo"
  envoy_gateway_config = {
    cluster_name              = "awesome_cluster"
    logging_level             = "debug"
    replicas_count            = 42
    resources_memory_limit    = "30g"
    resources_cpu_requests    = "5000mi"
    resources_memory_requests = "50g"
  }
}
