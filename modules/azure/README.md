# Azure Terraform modules

This directory contains all the Azure Terraform modules.

## Modules

- [`aks`](aks/README.md)
- [`aks-global`](aks-global/README.md)
- [`azure-pipelines-agent-vmss`](azure-pipelines-agent-vmss/README.md)
- [`core`](core/README.md)
- [`github-runner`](github-runner/README.md)
- [`governance-global`](governance-global/README.md)
- [`governance-regional`](governance-regional/README.md)
- [`hub`](hub/README.md)

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
    - `Application.ReadWrite.All` (`Azure Active Directory Graph` - it's under the `Supported legacy APIs` section - see the note below)
  - API Permissions: `Grant admin consent for <Tenant>`
  - Subscription permissions on all the subscriptions: `Owner`
  - The service principal also needs to be member of the `User administrator` role

Note regarding Azure Active Directory Graph: The AAD Graph has been deprecated and it's not possible to add it using the UI anymore. It will be completely decomissioned soon, but if you need it please add the following to your Azure AD App manifest:

```json
{
  "...",
	"requiredResourceAccess": [
		{
			"resourceAppId": "00000002-0000-0000-c000-000000000000",
			"resourceAccess": [
				{
					"id": "1cda74f2-2616-4834-b122-5cb1b07f8a59",
					"type": "Role"
				},
				{
					"id": "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175",
					"type": "Role"
				}
			]
		}
	],
  "..."
}
```
