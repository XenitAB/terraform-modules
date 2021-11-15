terraform {}

provider "kubernetes" {}

provider "helm" {}

module "prometheus" {
  source = "../../../modules/kubernetes/prometheus"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  remote_write_url              = "https://my-remote-writer.com"
  cloud_provider                = "azure"
  cluster_name                  = "aks1"
  environment                   = "dev"
  kube_state_metrics_namepsaces = ""
}
