# Contributing

This guide will help you get started contributing to this repo, with instructions to setup your
development environment and tips when developing.

## Setup

There are some dependencies that are required to be able to run the linters, checks and formatting.
The following tools are required to be installed on your local development machine to run the validation.
A tip is to use your favorite flavor of package manager like `brew` or `pacman` to make the
process simpler.
* [terraform](https://www.terraform.io/downloads.html)
* [tflint](https://github.com/terraform-linters/tflint)
* [terraform-docs](https://github.com/terraform-docs/terraform-docs)
* [tfsec](https://github.com/tfsec/tfsec)

If you are using macOS you will need to install a newer version of make, as the one included by default
is soon legally allowed to drink in Germany. The new make version will not remove the existing one
but instead install it as the command `gmake`.
```
brew install make
```

## Development

Eeach PR has a set of checks that are required to pass before it can be merged. This is to ensure consitency and stability in each
of the modules. You should run through all the make recipes before creating a PR to make sure that all of your HCL is formatted
correctly.
```
make
# or on macOS
gmake
```

### Creating a Module

Creating a new module is simple but has some non-obvious requirements for all of the checks to pass. First create a new module
directory in the 'modules' directory and in a fitting category directory. After the module is created a validation configuration
needs to be created for the module. In the 'validation' directory create a new directory with the same name and path as the module.
Inside there you should create a `main.tf` file which imports the module with a local path and passes dummy values for all of the
required variables, so that it is possible to run `terraform validate`.

## Your First Pull Request

These are the steps someone without contributor access needs to take to create a pull request:

1. Fork the repository using the GitHub
1. If you already have a fork, make sure it is up-to-date by pressing "Sync fork" in GitHub
1. Clone your fork to your local computer `git clone <github repo>`
1. Start a terminal inside the local repository and create a branch `git checkout -b <branch-name>`
1. Make all the neccesary changes
1. Make sure you have the neccesary tools installed locally to run the make commands. See [LOCAL_DEVELOPMENT](LOCAL_DEVELOPMENT.md) for more details.
1. Run `make all` and make sure nothing fails
1. Stage the changes using `git add <file>` (use `git status` to see all changed files)
1. Commit the changes using `git commit` and write a respectable commit message
1. Push the changes using `git push --set-upstream origin <branch-name>`
1. Go to your GitHub repository and pres "Compare & pull request"
1. Choose the correct base repository (should be XenitAB/terraform-modules main branch)
1. Make sure your commits and PR title conforms to [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/), where `type` should be one of `feat`,`fix`,`docs`,`test`,`ci`,`refactor`,`perf`,`chore`, or `revert`. Using a `scope` is optional. If used, it can be the module, using the following format: `module group/module`. Example: `fix(azure/core): <subject>`
1. Make sure you allow edits by maintainers
1. Then press Create pull request
1. INFO: A maintainer will be required to approve the checks to run before you will receive feedback from them
1. When all checks are passing and you have received an approval and a maintainer have merged the changes, press "Delete branch" in the PR
1. Locally, in the terminal, check out main using `git checkout main`
1. Remove the local branch using `git branch -D <branch-name>`
1. In your GitHub fork, press "Sync fork"
1. Locally, run `git pull`