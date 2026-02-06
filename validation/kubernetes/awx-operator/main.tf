terraform {}

module "awx-operator" {
  source     = "../../../modules/kubernetes/awx-operator"
  cluster_id = "sdc-sand-aks1"
  awx_config = {
    target_revision = "2.19.1"
    create_instance = true
    instance_name   = "awx"
    service_type    = "ClusterIP"
    ingress_type    = "none"
    hostname        = "xae.sand.xenit.example.io"
  }
  tenant_name = "unbox"
  environment = "sand"
  fleet_infra_config = {
    argocd_project_name = "unbox-sand-platform"
    git_repo_url        = "https://github.com/XenitAB/argocd-fleet-infra.git"
    k8s_api_server_url  = "https://kubernetes.default.svc"
  }
}
