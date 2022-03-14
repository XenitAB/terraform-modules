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
Inside there you should create a `m̀ain.tf` file which imports the module with a local path and passes dummy values for all of the
required variables, so that it is possible to run `terraform validate`.
