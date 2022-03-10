# Azure AD Kubernetes API Proxy
Adds [`azad-kube-proxy`](https://github.com/XenitAB/azad-kube-proxy) to a Kubernetes clusters.

## Configuring Azure AD Applications

### Azure AD App: azad-kube-proxy

```shell
ENVIRONMENT="dev"
TENANT_ID=$(az account show --output tsv --query tenantId)
AZ_APP_NAME="aks-${ENVIRONMENT}"
AZ_APP_URI="https://aks.${ENVIRONMENT}.example.com"
AZ_APP_ID=$(az ad app create --display-name ${AZ_APP_NAME} --identifier-uris ${AZ_APP_URI} --query appId -o tsv)
AZ_APP_OBJECT_ID=$(az ad app show --id ${AZ_APP_ID} --output tsv --query objectId)
AZ_APP_PERMISSION_ID=$(az ad app show --id ${AZ_APP_ID} --output tsv --query "oauth2Permissions[0].id")
az rest --method PATCH --uri "https://graph.microsoft.com/beta/applications/${AZ_APP_OBJECT_ID}" --body '{"api":{"requestedAccessTokenVersion": 2}}'
# Add Azure CLI as allowed client
az rest --method PATCH --uri "https://graph.microsoft.com/beta/applications/${AZ_APP_OBJECT_ID}" --body "{\"api\":{\"preAuthorizedApplications\":[{\"appId\":\"04b07795-8ddb-461a-bbee-02f9e1bf7b46\",\"permissionIds\":[\"${AZ_APP_PERMISSION_ID}\"]}]}}"
# This tag will enable discovery using kubectl azad-proxy discover
az rest --method PATCH --uri "https://graph.microsoft.com/beta/applications/${AZ_APP_OBJECT_ID}" --body '{"tags":["azad-kube-proxy"]}'
AZ_APP_SECRET=$(az ad sp credential reset --name ${AZ_APP_ID} --credential-description "azad-kube-proxy" --output tsv --query password)
az ad app permission add --id ${AZ_APP_ID} --api 00000003-0000-0000-c000-000000000000 --api-permissions 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role
az ad app permission admin-consent --id ${AZ_APP_ID}
```

### Azure KeyVault

```shell
JSON_FMT='{"client_id":"%s","client_secret":"%s","tenant_id":"%s"}'
KV_SECRET=$(printf "${JSON_FMT}" "${AZ_APP_ID}" "${AZ_APP_SECRET}" "${TENANT_ID}")
az keyvault secret set --vault-name <keyvault name> --name azad-kube-proxy --value "${KV_SECRET}"
```

## Terraform example (aks-core)

```terraform
data "azurerm_key_vault_secret" "azad_kube_proxy" {
  key_vault_id = data.azurerm_key_vault.core.id
  name         = "azad-kube-proxy"
}

module "aks_core" {
  source = "github.com/xenitab/terraform-modules//modules/kubernetes/aks-core?ref=[ref]"

  [...]

  azad_kube_proxy_enabled = true
  azad_kube_proxy_config = {
    fqdn                  = "aks.${var.dns_zone}"
    azure_ad_group_prefix = var.aks_group_name_prefix
    allowed_ips           = var.aks_authorized_ips
    azure_ad_app = {
      client_id     = jsondecode(data.azurerm_key_vault_secret.azad_kube_proxy.value).client_id
      client_secret = jsondecode(data.azurerm_key_vault_secret.azad_kube_proxy.value).client_secret
      tenant_id     = jsondecode(data.azurerm_key_vault_secret.azad_kube_proxy.value).tenant_id
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.azad_kube_proxy](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | The external IPs allowed through the ingress to azad-kube-proxy | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_azure_ad_app"></a> [azure\_ad\_app](#input\_azure\_ad\_app) | The Azure AD Application config for azad-kube-proxy | <pre>object({<br>    client_id     = string<br>    client_secret = string<br>    tenant_id     = string<br>  })</pre> | n/a | yes |
| <a name="input_azure_ad_group_prefix"></a> [azure\_ad\_group\_prefix](#input\_azure\_ad\_group\_prefix) | The Azure AD group prefix to filter for | `string` | `""` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | The name to use with the ingress (fully qualified domain name). Example: k8s.example.com | `string` | n/a | yes |

## Outputs

No outputs.
