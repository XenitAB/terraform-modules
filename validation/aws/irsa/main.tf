terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks" {
  source = "../../../modules/aws/irsa"

  name = "foobar"
  oidc_providers = [
    {
      url = "https://example.com"
      arn = ""
    }
  ]
  kubernetes_namespace         = "foo"
  kubernetes_service_account   = "bar"
  policy_json                  = "{\"foo\": \"bar\"}"
  extra_policy_permissions_arn = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}
