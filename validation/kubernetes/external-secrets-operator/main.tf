terraform {}

module "external_secrets_operator" {
  source = "../../../modules/kubernetes/external-secrets-operator"

  environment = "dev"
  cluster_id  = "foo"
  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
