terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks_core" {
  source = "../../../modules/kubernetes/eks-core"

  namespaces = []

  environment = "dev"

  external_dns_enabled = true
  external_dns_config = {
    role_arn = "bar"
  }

  velero_config = {
    s3_bucket_id = "foo"
    role_arn     = "bar"
  }

  cert_manager_enabled = true
  cert_manager_config = {
    notification_email = "foo"
    dns_zone           = "bar"
    role_arn           = "foobar"
  }
  #fluxcd_v2_config = {
  #  type = "github"
  #  github = {
  #    owner = ""
  #  }
  #  azure_devops = {
  #    pat  = ""
  #    org  = ""
  #    proj = ""
  #  }
  #}
  #external_secrets_config = {
  #  role_arn = "foobar"
  #}
  aad_groups = {
    view = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    edit = {
      test = {
        id   = "id"
        name = "name"
      }
    }
    cluster_admin = {
      id   = "id"
      name = "name"
    }
    cluster_view = {
      id   = "id"
      name = "name"
    }
    aks_managed_identity = {
      id   = "id"
      name = "name"
    }
  }
}
