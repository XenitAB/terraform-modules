terraform {}

provider "kubernetes" {}

provider "helm" {}

module "envoy-gateway" {
  source = "../../../modules/kubernetes/envoy-gateway"

  cluster_id = "foo"
  envoy_gateway_config = {
    cluster_name              = "awesome_cluster"
    logging_level             = "debug"
    replicas_count            = 42
    resources_memory_limit    = "30g"
    resources_cpu_requests    = "5000mi"
    resources_memory_requests = "50g"
    envoy_tls_policy_enabled  = true
  }
  azure_policy_enabled = true
  tenant_name          = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
