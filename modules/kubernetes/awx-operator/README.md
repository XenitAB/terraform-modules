# AWX Operator

This module deploys the [AWX Operator](https://github.com/ansible/awx-operator) to Kubernetes clusters.
AWX provides a web-based user interface, REST API, and task engine built on top of Ansible.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| git | >=0.0.4 |

## Providers

| Name | Version |
|------|---------|
| git | >=0.0.4 |

## Usage

```hcl
module "awx_operator" {
  source = "../../kubernetes/awx-operator"

  cluster_id = "sdc-sand-aks1"
  awx_config = {
    target_revision = "2.19.1"
    create_instance = true
    instance_name   = "awx"
    service_type    = "ClusterIP"
    ingress_type    = "ingress"
    hostname        = "awx.sandbox.example.com"
  }
  tenant_name = "unbox"
  environment = "sand"
  fleet_infra_config = {
    argocd_project_name = "unbox-sand-platform"
    git_repo_url        = "https://github.com/XenitAB/argocd-fleet-infra.git"
    k8s_api_server_url  = "https://kubernetes.default.svc"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | Unique identifier of the cluster | `string` | n/a | yes |
| environment | The environment name | `string` | n/a | yes |
| fleet_infra_config | Fleet infra configuration | `object` | n/a | yes |
| tenant_name | The name of the tenant | `string` | n/a | yes |
| awx_config | AWX Operator configuration | `object` | `{}` | no |

### awx_config

| Name | Description | Type | Default |
|------|-------------|------|---------|
| target_revision | Helm chart version | `string` | `"2.19.1"` |
| create_instance | Whether to create an AWX instance | `bool` | `true` |
| instance_name | Name of the AWX instance | `string` | `"awx"` |
| service_type | Kubernetes service type | `string` | `"ClusterIP"` |
| ingress_type | Ingress type (ingress, Route, none) | `string` | `"ingress"` |
| hostname | Hostname for the AWX instance | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace where AWX is deployed |
| instance_name | The name of the AWX instance |

## Post-Installation

After deployment, retrieve the admin password:

```bash
kubectl get secret awx-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode
```

Access AWX at the configured hostname or via port-forward:

```bash
kubectl port-forward svc/awx-service -n awx 8080:80
```
