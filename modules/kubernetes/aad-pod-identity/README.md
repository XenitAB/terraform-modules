## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |
| kubernetes | 1.13.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_pod\_identity | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| aad\_pod\_identity\_helm\_chart\_name | The helm chart name for aad-pod-identity | `string` | `"aad-pod-identity"` | no |
| aad\_pod\_identity\_helm\_chart\_version | The helm chart version for aad-pod-identity | `string` | `"2.0.0"` | no |
| aad\_pod\_identity\_helm\_release\_name | The helm release name for aad-pod-identity | `string` | `"aad-pod-identity"` | no |
| aad\_pod\_identity\_helm\_repository | The helm repository for aad-pod-identity | `string` | `"https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"` | no |
| aad\_pod\_identity\_namespace | The namespace for aad-pod-identity | `string` | `"aad-pod-identity"` | no |
| namespaces | The namespaces that should be created in Kubernetes. | <pre>list(<br>    object({<br>      name = string<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

