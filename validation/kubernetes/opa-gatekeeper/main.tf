terraform {}

provider "helm" {}

module "opa_gatekeeper" {
  source = "../../../modules/kubernetes/opa-gatekeeper"

  providers = {
    helm = helm
  }

  additional_excluded_namespaces = ["kube-system", "gatekeeper-system", "aad-pod-identity", "cert-manager", "ingress-nginx", "velero"]

  additional_constraints = [
    {
      kind = "AzureIdentityFormat"
      name = "azure-identity-format"
      enforcement_action = ""
      match = {
        kinds      = []
        namespaces = []
      }
      parameters = {}
    },
  ]
}
