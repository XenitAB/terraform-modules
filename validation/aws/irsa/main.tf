terraform {}

provider "aws" {
  region = "eu-west-1"
}

module "eks" {
  source = "../../../modules/aws/irsa"

  name = "foobar"
  oidc_urls = ["https://example.com"]
  kubernetes_namespace = "foo"
  kubernetes_service_account = "bar"
  policy_json = "{\"foo\": \"bar\"}"
}
