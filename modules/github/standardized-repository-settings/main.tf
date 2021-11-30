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
  owner = var.owner
  token = var.github_token
}

resource "github_repository" "this" {
  name        = var.repository_name
  description = var.repository_description

  allow_auto_merge       = true
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

resource "github_issue_label" "this" {
  for_each = {
    automation = {
      name        = "automation"
      color       = "63DC57"
      description = "Issue or PR that is created by non-human"
    },
    backlog = {
      name        = "backlog"
      color       = "B099EF"
      description = "Will be done at a later date"
    },
    breaking_change = {
      name        = "breaking change"
      color       = "B60205"
      description = "Breaking change"
    },
    bug = {
      name        = "bug"
      color       = "D73A4A"
      description = "Something isn't working"

    },
    documentation = {
      name        = "documentation"
      color       = "0075CA"
      description = "Improvements or additions to documentation"
    },
    duplicate = {
      name        = "duplicate"
      color       = "CFD3D7"
      description = "This issue or pull request already exists"
    },
    enhancement = {
      name        = "enhancement"
      color       = "A2EEEF"
      description = "This issue or pull request already exists"
    },
    good_first_issue = {
      name        = "good first issue"
      color       = "7057FF"
      description = "Good for newcomers"
    },
    help_wanted = {
      name        = "help wanted"
      color       = "008672"
      description = "Extra attention is needed"
    },
    ignore_changelog = {
      name        = "ignore changelog"
      color       = "221BD0"
      description = "Should not be mentioned in changelog"
    },
    invalid = {
      name        = "invalid"
      color       = "E4E669"
      description = "This doesn't seem right"
    },
    question = {
      name        = "question"
      color       = "D876E3"
      description = "Further information is requested"
    },
    wontfix = {
      name        = "wontfix"
      color       = "FFFFFF"
      description = "This will not be worked on"
    }
  }
  repository  = github_repository.this
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}
