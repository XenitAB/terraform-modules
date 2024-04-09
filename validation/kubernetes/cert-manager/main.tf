terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cert_manager" {
  source = "../../../modules/kubernetes/cert-manager"

<<<<<<< HEAD
  cluster_id         = "foobar"
=======
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

>>>>>>> 18fa30ff (Remove support for AWS cloud provider)
  notification_email = "example@example.com"
}
