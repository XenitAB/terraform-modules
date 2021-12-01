terraform {}

provider "github" {}

module "standardized_repository_settings" {
  source = "../../../modules/github/standardized-repository-settings"

  repository_name = "test"

  repository_description = "a description of a repo"

  repository_visibility = "private"

  required_status_checks = ["test", "ci"]
}
