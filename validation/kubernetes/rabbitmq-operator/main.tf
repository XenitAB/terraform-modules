terraform {}

provider "kubernetes" {}

provider "helm" {}

module "rabbitmq-operator" {
  source     = "../../../modules/kubernetes/rabbitmq-operator"
  cluster_id = "aks-prod-sdc-aks1"
  rabbitmq_config = {
    min_available          = 1
    replica_count          = 2
    spot_instances_enabled = false
    watch_namespaces       = []
  }
  tenant_name = "foo"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}