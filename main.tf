variable "github_token" {}

module "terraform-modules" {
  source = "./modules/github/validate-repository-settings"

  repository_name = "terraform-modules"
  github_token    = var.github_token
}
