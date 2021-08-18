terraform {}

provider "kubernetes" {}

provider "helm" {}

module "cluster_autoscaler" {
  source = "../../../modules/kubernetes/cluster-autoscaler"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cluster_name   = "foo"
  cloud_provider = "azure"
  aws_config = {
    role_arn = "bar"
    region   = "baz"
  }
}
