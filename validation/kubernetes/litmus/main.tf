terraform {}

provider "kubernetes" {}

module "litmus" {
  source = "../../../modules/kubernetes/litmus"

  azure_key_vault_name          = "my-key-vault"
  cluster_id                    = "aks1"
  key_vault_resource_group_name = "my-resource-group"
}