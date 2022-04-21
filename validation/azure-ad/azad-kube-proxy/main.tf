terraform {}

module "azad_kube_proxy" {
  source = "../../../modules/azure-ad/azad-kube-proxy"

  proxy_url    = "https://aks.dev.example.com"
  display_name = "example-aks-dev"
  cluster_name = "example-aks-dev"
}
