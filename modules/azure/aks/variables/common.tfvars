location               = "West Europe"
locationShort          = "we"
commonName             = "aks1"
subscriptionCommonName = "tflab"
aksCommonName          = "aks"
coreCommonName         = "core"

k8sSaNamespace = "service-accounts"

azdo_git_proxy = {
  chart             = "azdo-git-proxy"
  repository        = "https://xenitab.github.io/azdo-git-proxy/"
  version           = "v0.1.0-rc5"
  azdo_domain       = "dev.azure.com"
  azdo_organization = "xenitab"
}
