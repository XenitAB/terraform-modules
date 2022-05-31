terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azuread = {
      version = "2.19.1"
      source  = "hashicorp/azuread"
    }
  }
}
