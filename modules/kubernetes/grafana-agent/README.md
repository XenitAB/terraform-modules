# Azure AD Kubernetes API Proxy
Adds [`grafana-agent`](https://grafana.com/docs/agent/latest/) (the operator) to a Kubernetes clusters.

## Using the module (from aks-core)

### Azure KeyVault

```shell
METRICS_USERNAME="usr"
METRICS_PASSWORD="pw"
LOGS_USERNAME="usr"
LOGS_PASSWORD="pw"
TRACES_USERNAME="usr"
TRACES_PASSWORD="pw"

JSON_FMT='{"metrics_username":"%s","metrics_password":"%s","logs_username":"%s","logs_password":"%s","traces_username":"%s","traces_password":"%s"}'
KV_SECRET=$(printf "${JSON_FMT}" "${METRICS_USERNAME}" "${METRICS_PASSWORD}" "${LOGS_USERNAME}" "${LOGS_PASSWORD}" "${TRACES_USERNAME}" "${TRACES_PASSWORD}")
az keyvault secret set --vault-name [keyvault name] --name grafana-agent-credentials --value "${KV_SECRET}"
```

### Terraform example

```terraform
data "azurerm_key_vault_secret" "grafana_agent_credentials" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = "grafana-agent-credentials"
}

module "aks_core" {
  source = "github.com/xenitab/terraform-modules//modules/kubernetes/aks-core?ref=[ref]"

  [...]

  grafana_agent_enabled = true
  grafana_agent_config = {
    remote_write_urls = {
      metrics = "https://prometheus-foobar.grafana.net/api/prom/push"
      logs    = "https://logs-foobar.grafana.net/api/prom/push"
      traces  = "tempo-eu-west-0.grafana.net:443"
    }
    credentials = {
      metrics_username = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).metrics_username
      metrics_password = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).metrics_password
      logs_username    = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).logs_username
      logs_password    = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).logs_password
      traces_username  = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).traces_username
      traces_password  = jsondecode(data.azurerm_key_vault_secret.grafana_agent_credentials.value).traces_password
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana_agent_extras](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.grafana_agent_operator](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.kube_state_metrics](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubectl_manifest.grafana_agent_operator](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/secret) | resource |
| [helm_template.grafana_agent_operator](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/data-sources/template) | data source |
| [kubectl_file_documents.grafana_agent_operator](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the cluster name | `string` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | grafana-agent credentials | <pre>object({<br>    metrics_username = string<br>    metrics_password = string<br>    logs_username    = string<br>    logs_password    = string<br>    traces_username  = string<br>    traces_password  = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | the name of the environment | `string` | n/a | yes |
| <a name="input_extra_namespaces"></a> [extra\_namespaces](#input\_extra\_namespaces) | List of namespaces that should be enabled | `list(string)` | <pre>[<br>  "ingress-nginx"<br>]</pre> | no |
| <a name="input_namespace_include"></a> [namespace\_include](#input\_namespace\_include) | A list of the namespaces that kube-state-metrics should create metrics for | `list(string)` | n/a | yes |
| <a name="input_remote_write_urls"></a> [remote\_write\_urls](#input\_remote\_write\_urls) | the remote write urls | <pre>object({<br>    metrics = string<br>    logs    = string<br>    traces  = string<br>  })</pre> | <pre>{<br>  "logs": "",<br>  "metrics": "",<br>  "traces": ""<br>}</pre> | no |
| <a name="input_vpa_enabled"></a> [vpa\_enabled](#input\_vpa\_enabled) | Should vpa be enabled | `bool` | `false` | no |

## Outputs

No outputs.
