terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks_core" {
  source = "../../../modules/kubernetes/eks-core"

  environment    = "bar"
  namespaces     = []
  external_dns_config = {
    role_arn = "bar"
  }
  velero_config = {
    s3_bucket_id = "foo"
    role_arn = "bar"
  }
  cert_manager_config = {
    notification_email = "foo"
    dns_zone = "bar"
    role_arn = "foobar"
  }
  fluxcd_v2_config = {
    type = "github"
    github = {
      owner = ""
    }
    azure_devops = {
      pat  = ""
      org  = ""
      proj = ""
    }
  }
  external_secrets_config = {
    role_arn = "foobar"
  }
}
