# Xenit Terraform modules

This repository contains the Xenit Terraform modules.

## Module groups

- [`aws`](modules/aws/README.md)
- [`azure`](modules/azure/README.md)
- [`github`](modules/github/README.md)
- [`kubernetes`](modules/kubernetes/README.md)

## Contributing

Read the [contributing guide](./CONTRIBUTING.md) to get started writing modules.

## Style Guide

These modules use [tflint](https://github.com/terraform-linters/tflint) to enforce best practices, check the tflint configuration file in the modules
directory for details about which rules are enabled. The are also provider specific style guides in the individual directories for standards that only
apply to that provider. Following the standards below however will help you avoid the most common rule violations.

Every resource name should be lowercase and snakecased. No other format should be used in the resource names. The role assignment for a cluster admin
is named `cluster_admin` and not `clusterAdmin`.

```terraform
resource "azurerm_role_assignment" "cluster_admin" {
  scope = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.cluster_admin.id
}
```

Resources that only have a single instance and no fitting name that distinguishes it should use the name `this`. The reasoning is that it is more DRY
than reporting the resource type like `aks` which other people may do. However if there is a fitting name please use it. Additionally please do not
have to resources of the same type where one of them is called `this` and the other has a specific name, instead give both resources a specific name.

```terraform
resource "azurerm_kubernetes_cluster" "this" {
  name                            = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  dns_prefix                      = "aks-${var.environment}-${var.location_short}-${var.name}${var.aks_name_suffix}"
}
```
