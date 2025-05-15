terraform {}

module "nginx_gateway_fabric" {
  source         = "../../../modules/kubernetes/nginx-gateway-fabric"
  cluster_id     = "bar"
  gateway_config = {}
  nginx_config   = {}
  tenant_name    = "foo"
  environment    = "dev"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"
  }
}