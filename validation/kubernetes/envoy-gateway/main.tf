terraform {}

provider "kubernetes" {}

provider "helm" {}

module "envoy-gateway" {
  source = "../../../modules/kubernetes/envoy-gateway"

  cluster_id = "foo"
  envoy_gateway_config = {
    logging_level             = "debug"
    replicas_count            = 2
    resources_memory_limit    = "1Gi"
    resources_cpu_limit       = "1000m"
    resources_cpu_requests    = "100m"
    resources_memory_requests = "256Mi"
    proxy_cpu_limit           = "2000m"
    proxy_memory_limit        = "2Gi"
    proxy_cpu_requests        = "200m"
    proxy_memory_requests     = "512Mi"
  }
  tenant_name = "foo"
  environment = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}
