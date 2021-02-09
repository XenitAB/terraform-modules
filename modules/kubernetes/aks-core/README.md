# AKS Core

This module is used to create AKS clusters.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azuread | 1.0.0 |
| azurerm | 2.35.0 |
| flux | 0.0.8 |
| github | 4.1.0 |
| kubectl | 1.9.1 |
| kubernetes | 1.13.3 |
| random | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.35.0 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_groups | Configuration for aad groups | <pre>object({<br>    view = map(any)<br>    edit = map(any)<br>    cluster_admin = object({<br>      id   = string<br>      name = string<br>    })<br>    cluster_view = object({<br>      id   = string<br>      name = string<br>    })<br>    aks_managed_identity = object({<br>      id   = string<br>      name = string<br>    })<br>  })</pre> | n/a | yes |
| aad\_pod\_identity\_config | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| aad\_pod\_identity\_enabled | Should aad-pod-identity be enabled | `bool` | `true` | no |
| cert\_manager\_config | Cert Manager configuration | <pre>object({<br>    notification_email = string<br>    dns_zone           = string<br>  })</pre> | n/a | yes |
| cert\_manager\_enabled | Should Cert Manager be enabled | `bool` | `true` | no |
| csi\_secrets\_store\_provider\_azure\_enabled | Should csi-secrets-store-provider-azure be enabled | `bool` | `true` | no |
| datadog\_config | Datadog configuration | <pre>object({<br>    datadog_site = string<br>    api_key      = string<br>  })</pre> | <pre>{<br>  "api_key": "",<br>  "datadog_site": ""<br>}</pre> | no |
| datadog\_enabled | Should Datadog be enabled | `bool` | `false` | no |
| environment | The environment name to use for the deploy | `string` | n/a | yes |
| external\_dns\_config | External DNS configuration | <pre>object({<br>    client_id   = string<br>    resource_id = string<br>  })</pre> | n/a | yes |
| external\_dns\_enabled | Should External DNS be enabled | `bool` | `true` | no |
| falco\_enabled | Should Falco be enabled | `bool` | `false` | no |
| fluxcd\_v1\_config | Configuration for fluxcd-v1 | <pre>object({<br>    flux_status_enabled = bool<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | <pre>{<br>  "azure_devops": {<br>    "org": "",<br>    "pat": "",<br>    "proj": ""<br>  },<br>  "flux_status_enabled": false<br>}</pre> | no |
| fluxcd\_v1\_enabled | Should fluxcd-v1 be enabled | `bool` | `false` | no |
| fluxcd\_v2\_config | Configuration for fluxcd-v2 | <pre>object({<br>    type = string<br>    github = object({<br>      owner = string<br>    })<br>    azure_devops = object({<br>      pat  = string<br>      org  = string<br>      proj = string<br>    })<br>  })</pre> | n/a | yes |
| fluxcd\_v2\_enabled | Should fluxcd-v2 be enabled | `bool` | `true` | no |
| ingress\_nginx\_enabled | Should Ingress NGINX be enabled | `bool` | `true` | no |
| kubernetes\_network\_policy\_default\_deny | If network policies should by default deny cross namespace traffic | `bool` | `false` | no |
| kyverno\_enabled | Should Kyverno be enabled | `bool` | `true` | no |
| location\_short | The Azure region short name. | `string` | n/a | yes |
| name | The commonName to use for the deploy | `string` | n/a | yes |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name   = string<br>      labels = map(string)<br>      flux = object({<br>        enabled = bool<br>        github = object({<br>          repo = string<br>        })<br>        azure_devops = object({<br>          org  = string<br>          proj = string<br>          repo = string<br>        })<br>      })<br>    })<br>  )</pre> | n/a | yes |
| opa\_gatekeeper\_enabled | Should OPA Gatekeeper be enabled | `bool` | `true` | no |
| reloader\_enabled | Should Reloader be enabled | `bool` | `true` | no |
| velero\_config | Velero configuration | <pre>object({<br>    azure_storage_account_name      = string<br>    azure_storage_account_container = string<br>    identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>  })</pre> | n/a | yes |
| velero\_enabled | Should Velero be enabled | `bool` | `false` | no |

## Outputs

No output.

