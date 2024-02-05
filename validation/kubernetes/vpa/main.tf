terraform {}

module "vpa" {
  source = "../../../modules/kubernetes/vpa"

  cluster_id = "foobar"
}
