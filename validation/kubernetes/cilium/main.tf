terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cilium" {
  source = "../../../modules/kubernetes/cilium"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  k8s_service_host = "10.10.0.10"
  k8s_service_port = 443
}
