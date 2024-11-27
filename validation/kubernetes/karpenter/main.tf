terraform {}

provider "azurerm" {
  features {}
}

provider "kubernetes" {}

provider "helm" {}

module "karpenter" {
  source = "../../../modules/kubernetes/karpenter"

  aks_config = {
    cluster_id             = "id1"
    cluster_name           = "aks-dust-we-aks1"
    cluster_endpoint       = "https://foo.com:443"
    bootstrap_token        = "123.456"
    default_node_pool_size = 2
    node_identities        = "some-identity"
    node_resource_group    = "some-group_id"
    oidc_issuer_url        = "https://some-url"
    ssh_public_key         = "some-key"
    vnet_subnet_id         = "subnet1"
  }

  karpenter_config    = {}
  location            = "westeurope"
  resource_group_name = "rg-dust-we-aks1"
  subscription_id     = "id1"
}