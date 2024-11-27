terraform {}

provider "kubernetes" {}

provider "helm" {}

module "gateway_api" {
  source     = "../../../modules/kubernetes/gateway-api"
  cluster_id = "foo"
  gateway_api_config = {
    api_version = "v1.1.0"
    api_channel = "experimental"
  }
}