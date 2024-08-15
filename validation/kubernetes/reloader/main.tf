terraform {}


module "reloader" {
  source = "../../../modules/kubernetes/reloader"

  cluster_id = "foobar"
}
