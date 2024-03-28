terraform {}

module "external_dns" {
  source = "../../../modules/kubernetes/external-dns"

  cluster_id   = "foo"
  dns_provider = "azure"
  txt_owner_id = "dev-aks1"
  azure_config = {
    tenant_id       = "id"
    subscription_id = "id"
    resource_group  = "name"
    client_id       = "id"
  }
}
