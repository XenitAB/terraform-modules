# Grafana Alloy (Migration from Grafana Agent)

Adds [Grafana Alloy](https://github.com/grafana/alloy/tree/main/operations/helm) to a Kubernetes cluster. This module is designed to migrate from the `grafana-agent` module to `grafana-alloy` while maintaining similar functionality and configuration patterns.

## Migration Overview

This module replaces the Grafana Agent Operator with Grafana Alloy, providing equivalent functionality for:

- **Metrics Collection**: ServiceMonitor and PodMonitor support (compatible with existing Prometheus Operator CRDs)
- **Logs Collection**: Pod logs collection with namespace filtering
- **Traces Collection**: OTLP (HTTP/gRPC) and Jaeger protocol support
- **Kubelet Metrics**: Optional kubelet metrics scraping with namespace filtering
- **kube-state-metrics**: Continues to use the same kube-state-metrics chart

## Key Differences from grafana-agent

1. **Configuration Format**: Uses Alloy configuration language instead of Grafana Agent Operator CRDs (GrafanaAgent, MetricsInstance, LogsInstance)
2. **Deployment Type**: Uses a standard Deployment instead of the Grafana Agent Operator
3. **Credentials Management**: Uses Azure Key Vault via SecretProviderClass instead of hardcoded Kubernetes Secrets
4. **Azure Workload Identity**: Required for accessing credentials from Azure Key Vault
5. **Unified Agent**: Single agent for metrics, logs, and traces (instead of separate deployments)

## Features

- ✅ Metrics collection via ServiceMonitor/PodMonitor (Prometheus Operator compatibility)
- ✅ Pod logs collection with CRI format parsing
- ✅ OTLP traces receiver (HTTP and gRPC)
- ✅ Secure credentials from Azure Key Vault via SecretProviderClass
- ✅ Azure Workload Identity integration (required)te endpoints
- ✅ Azure Workload Identity integration
- ✅ Kubelet metrics scraping (optional)
- ✅ Namespace-based filtering
- ✅ kube-state-metrics integration
- ✅ Ingress-nginx observability

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.57.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |
| <a name="provider_git"></a> [git](#provider\_git) | >=0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.grafana_alloy](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/resources/federated_identity_credential) | resource |
| [git_repository_file.grafana_alloy](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_alloy_app](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_alloy_chart](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_alloy_extras](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_alloy_manifests](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.grafana_alloy_values](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [git_repository_file.kube_state_metrics](https://registry.terraform.io/providers/xenitab/git/latest/docs/resources/repository_file) | resource |
| [azurerm_user_assigned_identity.xenit](https://registry.terraform.io/providers/hashicorp/azurerm/4.57.0/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The AKS cluster short name, e.g. 'aks'. | `string` | n/a | yes |
| <a name="input_azure_config"></a> [azure\_config](#input\_azure\_config) | Azure specific configuration for Key Vault access | <pre>object({<br/>    azure_key_vault_name = string<br/>    keyvault_secret_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Unique identifier of the cluster across regions and instances. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The cluster name | `string` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | grafana-alloy credentials | <pre>object({<br/>    metrics_username = string<br/>    metrics_password = string<br/>    logs_username    = string<br/>    logs_password    = string<br/>    traces_username  = string<br/>    traces_password  = string<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_extra_namespaces"></a> [extra\_namespaces](#input\_extra\_namespaces) | List of namespaces that should be enabled | `list(string)` | <pre>[<br/>  "ingress-nginx"<br/>]</pre> | no |
| <a name="input_fleet_infra_config"></a> [fleet\_infra\_config](#input\_fleet\_infra\_config) | Fleet infra configuration | <pre>object({<br/>    git_repo_url        = string<br/>    argocd_project_name = string<br/>    k8s_api_server_url  = string<br/>  })</pre> | n/a | yes |
| <a name="input_include_kubelet_metrics"></a> [include\_kubelet\_metrics](#input\_include\_kubelet\_metrics) | If kubelet metrics shall be included for the namespaces in 'namespace\_include' | `bool` | `false` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | A list of the namespaces that kube-state-metrics and kubelet metrics | `list(string)` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | Kubernetes OIDC issuer URL for workload identity. | `string` | n/a | yes |
| <a name="input_remote_write_urls"></a> [remote\_write\_urls](#input\_remote\_write\_urls) | The remote write urls | <pre>object({<br/>    metrics = string<br/>    logs    = string<br/>    traces  = string<br/>  })</pre> | <pre>{<br/>  "logs": "",<br/>  "metrics": "",<br/>  "traces": ""<br/>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Azure resource group name | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of the tenant | `string` | n/a | yes |

## Outputs

No outputs.

## Migration Steps

To migrate from `grafana-agent` to `grafana-alloy-migration`:

1. **Create Azure Key Vault secrets**: Store credentials in Azure Key Vault with the following names:
   - `grafana-metrics-username`
   - `grafana-metrics-password`
   - `grafana-logs-username`
   - `grafana-logs-password`
   - `grafana-traces-username`
   - `grafana-traces-password`

2. **Grant Key Vault access**: Ensure the user-assigned identity has access to read secrets from the Key Vault.

3. **Update your Terraform code**:
   ```hcl
   # Replace this:
   module "grafana_agent" {
     source = "github.com/XenitAB/terraform-modules//modules/kubernetes/grafana-agent"
     
     cluster_id       = "example-cluster"
     cluster_name     = "example"
     environment      = "prod"
     tenant_name      = "platform"
     namespace_include = ["tenant1", "tenant2"]
     
     credentials = {
       metrics_username = "user"
       metrics_password = "pass"
       logs_username    = "user"
       logs_password    = "pass"
       traces_username  = "user"
       traces_password  = "pass"
     }
  **Security**: Credentials are stored in Azure Key Vault and mounted via SecretProviderClass, never stored in Kubernetes Secrets directly
- **Azure Workload Identity**: Required for authenticating to Azure Key Vault
- **Prometheus Operator Compatibility**: The module maintains compatibility with Prometheus Operator CRDs (ServiceMonitor, PodMonitor)
- **Label Selector**: Existing ServiceMonitors and PodMonitors with label `xkf.xenit.io/monitoring: tenant` will be automatically discovered
- **kube-state-metrics**: The module uses the same kube-state-metrics chart configuration as the grafana-agent module
- **Key Vault Secret Names**: Must match the expected names (grafana-metrics-username, grafana-metrics-password, etc.)
       traces  = "https://traces.example.com"
     }
     
     fleet_infra_config = {
       git_repo_url        = "https://github.com/example/fleet"
       argocd_project_name = "platform"
       k8s_api_server_url  = "https://kubernetes.default.svc"
     }
   }
   
   # With this:
   module "grafana_alloy" {
     source = "github.com/XenitAB/terraform-modules//modules/kubernetes/grafana-alloy-migration"
     
     cluster_id       = "example-cluster"
     cluster_name     = "example"
     environment      = "prod"
     tenant_name      = "platform"
     namespace_include = ["tenant1", "tenant2"]
     
     # Azure-specific configuration (required)
     aks_name             = "aks"
     location_short       = "we"
     resource_group_name  = "rg-example-prod"
     oidc_issuer_url      = "https://oidc.example.com"
     
     azure_config = {
       azure_key_vault_name = "kv-example-prod"
       keyvault_secret_name = "unused" # Can be any value, kept for compatibility
     }
     
     remote_write_urls = {
       metrics = "https://metrics.example.com"
       logs    = "https://logs.example.com"
       traces  = "https://traces.example.com"
     }
     
     fleet_infra_config = {
       git_repo_url        = "https://github.com/example/fleet"
       argocd_project_name = "platform"
       k8s_api_server_url  = "https://kubernetes.default.svc"
     }
   }
   ```

4. **Apply the changes**: The new module will create Grafana Alloy alongside or replace Grafana Agent based on your deployment strategy.

5. **Verify observability**: Ensure metrics, logs, and traces are flowing correctly to your remote write endpoints.

6. **Remove old module**: Once verified, you can safely remove the old `grafana-agent` module reference.

## Notes

- The module maintains compatibility with Prometheus Operator CRDs (ServiceMonitor, PodMonitor)
- Existing ServiceMonitors and PodMonitors with label `xkf.xenit.io/monitoring: tenant` will be automatically discovered
- The module uses the same kube-state-metrics chart configuration as the grafana-agent module
- Azure Workload Identity is automatically configured for accessing Azure Key Vault
