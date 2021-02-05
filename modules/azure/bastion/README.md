# Hub

This module is used to create a Azure Bastion host in production subscription.

## Usage

Use together with the `hub` module to create a Azure Bastion host.

## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.5 |
| azurerm | 2.35.0 |
| random | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 2.35.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_subnet\_config | configuration for all Bastion host subnets | <pre>map(object({<br>    name = string<br>    cidr = string<br>  }))</pre> | n/a | yes |
| environment | The environment (short name) to use for the deploy | `string` | n/a | yes |
| name | The name to use for the deploy | `string` | n/a | yes |
| regions | The Azure Regions to configure | <pre>list(object({<br>    location       = string<br>    location_short = string<br>  }))</pre> | n/a | yes |
| vnet\_config | Address spaces used by virtual network. | <pre>map(object({<br>    address_space = list(string)<br>    subnets = list(object({<br>      name              = string<br>      cidr              = string<br>      service_endpoints = list(string)<br>    }))<br>  }))</pre> | n/a | yes |
| vnet\_name | Virtual network name | `string` | n/a | yes |

## Outputs

No output.

