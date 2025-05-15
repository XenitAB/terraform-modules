# Azure Policy

Adds [`Azure Policy for Kubernetes`](https://github.com/Azure/azure-policy) to a Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.azure_identity_format](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.azure_remove_node_spot_taints](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_block_node_port](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_pod_priority_class](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_require_ingress_class](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.k8s_secrets_store_csi_unique_volume](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.mutations](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.xks](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/policy_set_definition) | resource |
| [azurerm_resource_policy_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/resources/resource_policy_assignment) | resource |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.19.0/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | The commonName to use for the deploy | `string` | n/a | yes |
| <a name="input_aks_name_suffix"></a> [aks\_name\_suffix](#input\_aks\_name\_suffix) | The suffix for the aks clusters | `number` | n/a | yes |
| <a name="input_azure_policy_config"></a> [azure\_policy\_config](#input\_azure\_policy\_config) | A list of Azure policy mutations to create and include in the XKS policy set definition | <pre>object({<br/>    exclude_namespaces = list(string)<br/>    mutations = list(object({<br/>      name         = string<br/>      display_name = string<br/>      template     = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "exclude_namespaces": [<br/>    "linkerd",<br/>    "linkerd-cni",<br/>    "velero",<br/>    "grafana-agent"<br/>  ],<br/>  "mutations": [<br/>    {<br/>      "display_name": "Containers should not use privilege escalation",<br/>      "name": "ContainerNoPrivilegeEscalation",<br/>      "template": "container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Containers should drop disallowed capabilities",<br/>      "name": "ContainerDropCapabilities",<br/>      "template": "container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Containers should use a read-only root filesystem",<br/>      "name": "ContainerReadOnlyRootFs",<br/>      "template": "container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should not use privilege escalation",<br/>      "name": "EphemeralContainerNoPrivilegeEscalation",<br/>      "template": "ephemeral-container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should drop disallowed capabilities",<br/>      "name": "EphemeralContainerDropCapabilities",<br/>      "template": "ephemeral-container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Ephemeral containers should use a read-only root filesystem",<br/>      "name": "EphemeralContainerReadOnlyRootFs",<br/>      "template": "ephemeral-container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should not use privilege escalation",<br/>      "name": "InitContainerNoPrivilegeEscalation",<br/>      "template": "init-container-disallow-privilege-escalation.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should drop disallowed capabilities",<br/>      "name": "InitContainerDropCapabilities",<br/>      "template": "init-container-drop-capabilities.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Init containers should use a read-only root filesystem",<br/>      "name": "InitContainerReadOnlyRootFs",<br/>      "template": "init-container-read-only-root-fs.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Pods should use an allowed seccomp profile",<br/>      "name": "PodDefaultSecComp",<br/>      "template": "k8s-pod-default-seccomp.yaml.tpl"<br/>    },<br/>    {<br/>      "display_name": "Pods should not automount service account tokens",<br/>      "name": "PodServiceAccountTokenNoAutoMount",<br/>      "template": "k8s-pod-serviceaccount-token-false.yaml.tpl"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to use for the deploy | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | The Azure region short name. | `string` | n/a | yes |

## Outputs

No outputs.
