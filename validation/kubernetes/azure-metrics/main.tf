terraform {}

module "azure_metrics" {
  source = "../../../modules/kubernetes/azure-metrics"

  client_id       = "1234"
  subscription_id = "0987"
  cluster_id      = "foo"
}
