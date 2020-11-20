terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
  }
}

module "opa_gatekeeper" {
  source = "../../../modules/kubernetes/opa-gatekeeper"

  providers = {
    helm = helm
  }

  exclude = [
    {
      excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero"]
      processes           = ["*"]
    }
  ]

  additional_constraints = [
    {
      kind = "AzureIdentityFormat"
      name = "azure-identity-format"
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
  ]
}
