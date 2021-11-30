/**
  * This module sets up a GitHub repository in a standardized way, to ensure
  * consistency among things like branch and PR handling, labels and so on.
  */

terraform {
  required_version = "0.15.3"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.18.0"
    }
  }
}

provider "github" {
  owner = "XenitAB"
  token = var.github_token
}

resource "github_repository" "this" {
  name        = var.repository_name
  description = var.repository_description

  allow_auto_merge       = false
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  delete_branch_on_merge = true
  has_downloads          = false
  has_issues             = true
  has_wiki               = false
  visibility             = var.repository_visibility
  vulnerability_alerts   = var.vulnerability_alerts
}

resource "github_branch_protection" "this" {
  repository_id          = github_repository.this
  pattern                = "main"
  enforce_admins         = true
  require_signed_commits = true
  required_pull_request_reviews {
    required_approving_review_count = 1
  }
  required_status_checks {
    contexts = var.required_status_checks
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this
  branch     = "main"
}

resource "github_issue_label" "automation_label" {
  repository  = github_repository.this
  name        = "automation"
  color       = "63DC57"
  description = "Issue or PR that is created by non-human"
}

resource "github_issue_label" "backlog_label" {
  repository  = github_repository.this
  name        = "backlog"
  color       = "B099EF"
  description = "Will be done at a later date"
}

resource "github_issue_label" "breaking_change_label" {
  repository  = github_repository.this
  name        = "breaking change"
  color       = "B60205"
  description = "Breaking change"
}

resource "github_issue_label" "bug_label" {
  repository  = github_repository.this
  name        = "bug"
  color       = "D73A4A"
  description = "Something isn't working"
}

resource "github_issue_label" "documentation_label" {
  repository  = github_repository.this
  name        = "documentation"
  color       = "0075CA"
  description = "Improvements or additions to documentation"
}

resource "github_issue_label" "duplicate_label" {
  repository  = github_repository.this
  name        = "duplicate"
  color       = "CFD3D7"
  description = "This issue or pull request already exists"
}

resource "github_issue_label" "enhancement_label" {
  repository  = github_repository.this
  name        = "enhancement"
  color       = "A2EEEF"
  description = "This issue or pull request already exists"
}

resource "github_issue_label" "good_first_issue_label" {
  repository  = github_repository.this
  name        = "good first issue"
  color       = "7057FF"
  description = "Good for newcomers"
}

resource "github_issue_label" "help_wanted_label" {
  repository  = github_repository.this
  name        = "help wanted"
  color       = "008672"
  description = "Extra attention is needed"
}

resource "github_issue_label" "ignore_changelog_label" {
  repository  = github_repository.this
  name        = "ignore changelog"
  color       = "221BD0"
  description = "Should not be mentioned in changelog"
}

resource "github_issue_label" "invalid_label" {
  repository  = github_repository.this
  name        = "invalid"
  color       = "E4E669"
  description = "This doesn't seem right"
}

resource "github_issue_label" "question_label" {
  repository  = github_repository.this
  name        = "question"
  color       = "D876E3"
  description = "Further information is requested"
}

resource "github_issue_label" "wontfix_label" {
  repository  = github_repository.this
  name        = "wontfix"
  color       = "FFFFFF"
  description = "This will not be worked on"
}
