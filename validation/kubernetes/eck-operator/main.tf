terraform {}

provider "kubernetes" {}

provider "helm" {}

module "eck-operator" {
  source                 = "../../../modules/kubernetes/eck-operator"
  cluster_id             = "yabadabadoo"
  eck_managed_namespaces = []
}
