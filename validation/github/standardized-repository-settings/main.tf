terraform {}

provider "github" {}

module "standardized_repository_settings" {
  source = "../../../modules/github/standardized-repository-settings"

  providers = {
    github = github
  }

  repository_name = "test"

  repository_description = "a description of a repo"

  repository_visibility = "private"

  github_token = "ghp_thisisfake"

  required_status_checks = ["test", "ci"]
}
