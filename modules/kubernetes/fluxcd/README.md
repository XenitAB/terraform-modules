## Overview

This module now provisions Flux v2 via a GitOps-first pattern using Argo CD Applications and Git commits only. It no longer performs an imperative bootstrap with the Flux provider nor deploys `git-auth-proxy`. All cluster-side Flux controllers are installed by Argo CD rendering the official `flux2` Helm chart (OCI) referenced from a generated Application manifest.

Workload Identity (Azure AD workload / OIDC) is supported for the `source-controller` by default and can optionally be enabled for other controllers.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| azurerm   | 4.19.0 |
| git       | >=0.0.4 |

## Providers Used

| Provider | Purpose |
|----------|---------|
| azurerm  | Identity + role assignments |
| git      | Commit generated Argo/Flux manifests |

## What Gets Generated in the Git Repository

```
platform/<tenant_name>/<cluster_id>/templates/flux-app.yaml                # App-of-apps Argo CD Application
platform/<tenant_name>/<cluster_id>/argocd-applications/flux/Chart.yaml     # Meta chart scaffold
platform/<tenant_name>/<cluster_id>/argocd-applications/flux/values.yaml    # Placeholder values
platform/<tenant_name>/<cluster_id>/argocd-applications/flux/templates/flux.yaml  # Flux controllers Argo CD Application
tenants/<cluster_id>/<tenant>.yaml                                         # Flux multitenancy (GitRepository/Kustomization/Provider/SA)
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acr_name_override | Override default name of ACR | `string` | `""` | no |
| aks_managed_identity | AKS Azure AD managed identity | `string` | yes | yes |
| aks_name | The commonName to use for the deploy | `string` | n/a | yes |
| cluster_id | Unique identifier for the cluster | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| flux2_chart_version | Flux2 Helm chart version | `string` | `2.13.0` | no |
| git_provider | Git provider config (github or azuredevops). PAT no longer used; Azure DevOps access must rely on public repos or future managed identity integration. | object | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| location_short | Azure region short name | `string` | n/a | yes |
| namespaces | Flux tenant definitions | list(object) | `[]` | no |
| oidc_issuer_url | AKS OIDC issuer URL | `string` | n/a | yes |
| resource_group_name | Resource group name | `string` | n/a | yes |
| tenant_name | Logical tenant name used for Argo CD scoping | `string` | n/a | yes |
| fleet_infra_config | Argo CD/fleet infra settings (repo URL, project, api server) | object | n/a | yes |
| unique_suffix | Optional uniqueness affix for global names | `string` | `""` | no |
| enable_workload_identity_all_controllers | Add federated creds & annotations for all controllers | `bool` | `false` | no |

### namespaces.fluxcd object shape
```
fluxcd = {
	provider            = string            # "github" | "azuredevops"
	project             = optional(string)  # Azure DevOps project (PAT not required; repository must be accessible over anonymous https)
	repository          = string            # Repo name
	include_tenant_name = optional(bool, false)
	create_crds         = optional(bool, true)
}
```

## Workload Identity

The module creates one user-assigned managed identity plus a federated credential for:
- `system:serviceaccount:flux-system:source-controller` (always)
- Optionally for: `kustomize-controller`, `helm-controller`, `notification-controller` when `enable_workload_identity_all_controllers = true`.

Helm values inject `azure.workload.identity/client-id` annotations onto corresponding ServiceAccounts.

## Migration Notes (from previous version)

| Old Concept | New Equivalent |
|-------------|----------------|
| flux_bootstrap_git resource | Argo CD Application (`flux.yaml` inside chart) installing `flux2` chart |
| git-auth-proxy | Removed (direct URLs used) |
| kustomization-override patch | Replaced by Helm chart + static Application values |
| bootstrap.* inputs | Deprecated (ignored) |

If you previously passed `bootstrap` you may safely retain it in calling code; it is ignored. Remove it when convenient.

## Outputs

None currently. Potential future outputs: identity client id, tenant manifest paths.

## Future Enhancements
- Optional output for managed identity client ID
- Additional Helm value overrides via module input
- Support for image reflector/automation controllers toggle

## Example Usage
```
module "fluxcd" {
	source              = "../../kubernetes/fluxcd"
	environment         = var.environment
	cluster_id          = local.cluster_id
	tenant_name         = var.platform_config.tenant_name
	fleet_infra_config  = var.platform_config.fleet_infra_config
	git_provider        = var.fluxcd_config.git_provider
	oidc_issuer_url     = var.oidc_issuer_url
	resource_group_name = data.azurerm_resource_group.this.name
	location            = data.azurerm_resource_group.this.location
	location_short      = var.location_short
	aks_name            = var.name
	aks_managed_identity = data.azuread_group.aks_managed_identity.id
	namespaces          = [for ns in var.namespaces : { name = ns.name, labels = ns.labels, fluxcd = ns.flux }]
	enable_workload_identity_all_controllers = true
}
```
