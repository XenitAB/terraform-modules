This module sets up a GitHub repository in a standardized way, to ensure
consistency among things like branch and PR handling, labels and so on.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 4.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_branch_default.this](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/branch_default) | resource |
| [github_branch_protection.this](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/branch_protection) | resource |
| [github_issue_label.automation_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.backlog_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.breaking_change_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.bug_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.documentation_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.duplicate_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.enhancement_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.good_first_issue_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.help_wanted_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.ignore_changelog_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.invalid_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.question_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_issue_label.wontfix_label](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/4.18.0/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Token used to access GitHub | `string` | n/a | yes |
| <a name="input_repository_description"></a> [repository\_description](#input\_repository\_description) | Description for this repository | `string` | `"No description"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the repository | `string` | n/a | yes |
| <a name="input_repository_visibility"></a> [repository\_visibility](#input\_repository\_visibility) | The visibility of the repository ('private' or 'public') | `string` | `"private"` | no |
| <a name="input_required_status_checks"></a> [required\_status\_checks](#input\_required\_status\_checks) | Status checks that need to pass to merge a PR to the main branch | `list(string)` | <pre>[<br>  "test"<br>]</pre> | no |

## Outputs

No outputs.
