terraform {}

provider "azuread" {}

module "xkf_global" {
  source = "../../../modules/azure/xkf-governance-global"

  environment       = "dev"
  subscription_name = "xks"

  namespaces = [
    {
      name = "team1"
      labels = {
        "test" = "test"
      }
      flux = {
        enabled = true
        repo    = "repo"
      }
    }
  ]

  group_name_prefix = "aks"

  azuread_groups = {
    rg_owner = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    rg_contributor = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    rg_reader = {
      test = {
        id = "00000000-0000-0000-0000-000000000000"
      }
    }
    sub_owner = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    sub_contributor = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    sub_reader = {
      id = "00000000-0000-0000-0000-000000000000"
    }
    service_endpoint_join = {
      id = "00000000-0000-0000-0000-000000000000"
    }
  }
}
