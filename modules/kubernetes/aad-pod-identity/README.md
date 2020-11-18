## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| helm | 1.3.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_pod\_identity | Configuration for aad pod identity | <pre>map(object({<br>    id        = string<br>    client_id = string<br>  }))</pre> | n/a | yes |
| namespaces | Namespaces to create AzureIdentity and AzureIdentityBindings in. | <pre>list(<br>    object({<br>      name = string<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No output.

