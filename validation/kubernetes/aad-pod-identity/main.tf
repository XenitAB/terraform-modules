terraform {}

provider "kubernetes" {}

provider "helm" {}

module "aad_pod_identity" {
  source = "../../../modules/kubernetes/aad-pod-identity"

  cluster_id = "foobar"
  aad_pod_identity = {
    "test" = {
      id        = "id"
      client_id = "id"
    }
  }

  namespaces = [
    {
      name = "team1"
    }
  ]

  tenant_name = "foo"
  fleet_infra_config = {
    argocd_project_name = "foo-fleet-infra"
    git_repo_url        = "http://some-git-repo.git"
    k8s_api_server_url  = "http://kubernetes.default.svc"

  }
}
