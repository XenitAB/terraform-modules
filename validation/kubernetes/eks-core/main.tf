terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks_core" {
  source = "../../../modules/kubernetes/eks-core"

  namespaces = []

  environment     = "dev"
  name            = "foo"
  eks_name_suffix = 1

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
    dns_zone           = ["example.com", "example.io"]
    role_arn           = "foobar"
  }
  cluster_autoscaler_config = {
    role_arn = "foobar"
  }
  fluxcd_v2_config = {
    type = "github"
    github = {
      org             = ""
      app_id          = 0
      installation_id = 0
      private_key     = ""
    }
    azure_devops = {
      pat  = ""
      org  = ""
      proj = ""
    }
  }

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

  ingress_config = {
    http_snippet              = ""
    public_private_enabled    = false
    allow_snippet_annotations = false
  }

  starboard_enabled = true

  starboard_config = {
    starboard_role_arn = "arn1234"
    trivy_role_arn     = "arn1234"
  }

  prometheus_enabled = true
  prometheus_config = {
    role_arn = "foo"

    tenant_id = ""

    remote_write_authenticated = true
    remote_write_url           = "https://my-receiver.com"

    volume_claim_storage_class_name = "default"
    volume_claim_size               = "5Gi"

    resource_selector  = ["platform"]
    namespace_selector = ["platform"]
  }

  promtail_enabled = true
  promtail_config = {
    role_arn            = "foo"
    loki_address        = "value"
    excluded_namespaces = []
  }
}
