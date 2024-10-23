terraform {}

provider "kubernetes" {}

provider "helm" {}

module "nginx_gateway_fabric" {
  source         = "../../../modules/kubernetes/nginx-gateway-fabric"
  cluster_id     = "bar"
  gateway_config = {}
  nginx_config   = {}
}