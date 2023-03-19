# Azure Terraform modules

This directory contains all the Azure Terraform modules.

## Modules

- [`aks-global`](aks-global/README.md)
- [`aks-regional`](aks-regional/README.md)
- [`aks`](aks/README.md)
- [`azure-pipelines-agent-vmss`](azure-pipelines-agent-vmss/README.md)
- [`core`](core/README.md)
- [`github-runner`](github-runner/README.md)
- [`governance-global`](governance-global/README.md)
- [`governance-regional`](governance-regional/README.md)
- [`hub`](hub/README.md)
- [`names`](names/README.md)
- [`xkf-governance-global-data`](xkf-governance-global-data/README.md)
- [`xkf-governance-global`](xkf-governance-global/README.md)

## Style Guide

TBD

## Getting started

### Azure Service Principal (owner)

INFO: This service principal will be used to run `governance-global`, `governance-regional`, `core`, `aks-global`, `aks` and `hub` modules. Running other modules, like `azure-pipelines-agent-vmss` can be done with the service principals that are created and stored in the core Azure KeyVault.

Create and delegate access to the `owner` service principal:

- Create new service principal: `sp-sub-<subscription_name>-all-owner`
- Create three Azure AD groups:
  - Owner group: `az-sub-<subscription_name>-all-owner`
  - Contributor group: `az-sub-<subscription_name>-all-contributor`
  - Reader group: `az-sub-<subscription_name>-all-reader`
- Grant service principal the following permissions:
  - API Permissions: (Application)
    - `Group.ReadWrite.All` (`Microsoft Graph`)
    - `Application.ReadWrite.All` (`Microsoft Graph`)
  - API Permissions: `Grant admin consent for <Tenant>`
  - Subscription permissions on all the subscriptions: `Owner`
  - The service principal also needs to be member of the `User administrator` role

### Migrating to Azure AD v2 provider

If you are using the Azure AD v1 provider and start using the v2 provider, please follow the below steps:

- Add API permission `Application.ReadWrite.All` (`Microsoft Graph`) to the service principal(s)

  - Remove the following from the state: module.governance_global.data.azuread_application.owner_spn (related [issue](https://github.com/hashicorp/terraform-provider-azuread/issues/541))

  ```shell
   make state-remove ENV=dev DIR=governance
   confirm: governance/dev
   regexp: data.azuread_application
  ```

- Run plan / apply, validate that only `random_password` resources are removed
- Remove service principal(s) from the `User administrator` role
- Remove the `Application.ReadWrite.All` (`Azure Active Directory Graph`) permission and admin consent from the service principal(s)
- Remove the `Directory.ReadWrite.All` (`Azure Active Directory Graph`) permission and admin consent from the service principal(s) if it exists
