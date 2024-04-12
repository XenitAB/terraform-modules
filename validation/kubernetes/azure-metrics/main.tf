terraform {}

provider "kubernetes" {}

provider "helm" {}

module "azure_metrics" {
  source = "../../../modules/kubernetes/azure-metrics"

  client_id       = "1234"
  resource_id     = "5678"
  subscription_id = "0987"
  cluster_id      = "foo"
}
