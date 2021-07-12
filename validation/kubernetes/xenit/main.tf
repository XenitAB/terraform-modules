terraform {}

provider "kubernetes" {}

provider "helm" {}

module "xenit" {
  source = "../../../modules/kubernetes/xenit"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  cloud_provider = "azure"
  azure_config = {
    azure_key_vault_name = ""
    identity = {
      client_id   = ""
      resource_id = ""
      tenant_id   = ""
    }
  }

  thanos_receiver_fqdn = "receiver.example.com"
  loki_api_fqdn        = "loki.example.com"
}
