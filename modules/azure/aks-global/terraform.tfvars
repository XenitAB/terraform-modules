location               = "West Europe"
location_short          = "we"
name             = "aks"
subscription_name = "tflab"
aks_name          = "aks"
core_name         = "core"

namespaces = [
  {
    name = "site"
    delegate_resource_group = true
    labels = {
      "terraform" = "true"
    }
    flux = {
      enabled = false
      azdo_org = ""
      azdo_project = ""
      azdo_repo = ""
    }
  }
]

environment = "dev"
dns_zone          = "tflab-dev.xenit.io"

aks_authorized_ips = []
