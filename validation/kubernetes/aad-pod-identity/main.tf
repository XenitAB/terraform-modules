terraform {}

provider "kubernetes" {}

provider "helm" {}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  aad_pod_identity = {
    "test" = {
      id        = "id"
      client_id = "id"
    }
  }

  namespaces = [
    {
      name = "team1"
    }
  ]
}
