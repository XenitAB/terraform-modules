# Your first Pull Request

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
1. Write a respectable subject and body for the PR, make sure to reference your issue using "Fixes #<issue number>"
1. Make sure the subject starts with <module base>/<module>, example: `azure/core: <subject>`
1. Make sure you allow edits by maintainers
1. Then press Create pull request
1. INFO: A maintainer will be required to approve the checks to run before you will receive feedback from them
1. When the PR is created, you will receive a PR number. It is required to update the [CHANGELOG.md](CHANGELOG.md) with this PR before all checks will pass
1. When all checks are passing and you have received an approval and a maintainer have merged the changes, press "Delete branch" in the PR
1. Locally, in the terminal, check out main using `git checkout main`
1. Remove the local branch using `git branch -D <branch-name>`
1. In your GitHub fork, press "Sync fork"
1. Locally, run `git pull`