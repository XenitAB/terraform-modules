location               = "West Europe"
locationShort          = "we"
commonName             = "aks"
subscriptionCommonName = "tflab"
aksCommonName          = "aks"
coreCommonName         = "core"

k8sNamespaces = [
  {
    name       = "site"
    delegateRg = true
    labels = {
      "terraform" = "true"
    }
  }
]
