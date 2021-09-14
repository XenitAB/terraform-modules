# OPA Gatekeeper

Adds [`opa-gatekeeper`](https://github.com/open-policy-agent/gatekeeper) and [gatekeeper-library](https://github.com/xenitab/gatekeeper-library) to a Kubernetes clusters.

Running the gatekeeper is a prerequirement for the library to work, as the library only adds different types of constraints that are used by gatekeeper.
Constraints are added through first creating a `ConstraintTemplate` and then adding a `Constraint` that enforces the template. The module constains a list of default
constraints in the `default_constraints` that are recomended to always be applied. These constraints are cloud agnostic and are either re-implemetnations of specific PSPs
or orginal constraints meant to enforce best practices. The default constraints will be added if you do not override this variable with either a list of different
constraints or an empty list. By default all namespaces expect those specified in the `excludes` namespaces will have the constraints enforced. What this means is that
if a resource does does comform to the constraints added by this module they will not be allowed to be created and will fail when applying.

Constraints configuration are given in a specific object format that is compatible with the gatekeeper-library values format. The module makes sure that both templates
and the constraints are created. The example below would create a template with the kind of `K8sPSPVolumeTypes` which gatekeeper will create a CRD from, and a constraint
resource of kind `K8sPSPVolumeTypes` that enforces the rule.
```hcl
{
  kind               = "K8sPSPVolumeTypes"
  name               = "psp-volume-types"
  enforcement_action = ""
  match = {
    kinds      = []
    namespaces = []
  }
  parameters = {
    volumes = ["configMap", "downwardAPI", "emptyDir", "persistentVolumeClaim", "secret", "projected"]
  }
}
```

Certain fields in the configuration object are required while others are not. The `kind` and `name` field are obviously required as they determine which template and constraint
that should be created. Other fiels such as `enforcement_action`, `match.kinds`, `parameters` do not always have to be set as they receive default values from the Helm chart.
Check the [defaults file](https://github.com/XenitAB/gatekeeper-library/blob/master/charts/gatekeeper-library-constraints/generated/defaults.yaml) in gatekeeper-library to see
what the default values are. It is reccomended to leave the `match.kinds` to the default value as most constraints act on specific resource types, and the default value is
set to right right kind. With the configuration above the following template and constraint will be created. Note the `mathc.kinds` field in the constraint resource.
```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8spspvolumetypes
spec:
  crd:
    spec:
      names:
        kind: K8sPSPVolumeTypes
      validation:
        openAPIV3Schema:
          properties:
            volumes:
              items:
                type: string
              type: array
  targets:
  - target: admission.k8s.gatekeeper.sh
    rego: {REGO}
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPVolumeTypes
metadata:
  name: psp-volume-types
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  parameters:
    volumes:
    - configMap
    - downwardAPI
    - emptyDir
    - persistentVolumeClaim
    - secret
    - projected
```

New constraints have to be added to [gatekeeper-library](https://github.com/xenitab/gatekeeper-library) with a new version of the Helm chart. Then the Helm chart version
can be updated in the module, which enables use of the new constraints.

The gatekeeper-library requires two Helm charts for things to work, one that first sets up `ConstraintTemplate` and after that one that creates the `Constraint`. This has
to be done as otherwise there would be a chicken and the egg problem with the CRDs created by the `ConstraintTemplate`. This behavior is not visibile outside of the module
as the same values are passed to both of the charts, there will never be a difference between the constraints created and the templates that exist.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.15.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.gatekeeper](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.gatekeeper_constraints](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.gatekeeper_templates](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_assigns"></a> [additional\_assigns](#input\_additional\_assigns) | Additional assigns that should be added | <pre>list(object({<br>    name = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_constraints"></a> [additional\_constraints](#input\_additional\_constraints) | Additional constraints that should be added | <pre>list(object({<br>    kind               = string<br>    name               = string<br>    enforcement_action = string<br>    match = object({<br>      kinds = list(object({<br>        apiGroups = list(string)<br>        kinds     = list(string)<br>      }))<br>      namespaces = list(string)<br>    })<br>    parameters = any<br>  }))</pre> | `[]` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use. | `string` | `"azure"` | no |
| <a name="input_enable_default_assigns"></a> [enable\_default\_assigns](#input\_enable\_default\_assigns) | If enabled default assigns will be added | `bool` | `true` | no |
| <a name="input_enable_default_constraints"></a> [enable\_default\_constraints](#input\_enable\_default\_constraints) | If enabled default constraints will be added | `bool` | `true` | no |
| <a name="input_excluded_namespaces"></a> [excluded\_namespaces](#input\_excluded\_namespaces) | Namespaces to opt out of constraints and assigns | `list(string)` | <pre>[<br>  "kube-system",<br>  "gatekeeper-system"<br>]</pre> | no |

## Outputs

No outputs.
