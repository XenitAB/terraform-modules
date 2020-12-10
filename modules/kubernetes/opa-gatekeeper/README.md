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
| terraform | 0.13.5 |
| helm | 1.3.2 |

## Providers

| Name | Version |
|------|---------|
| helm | 1.3.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_constraints | Additional constraints that should be added | <pre>list(object({<br>    kind               = string<br>    name               = string<br>    enforcement_action = string<br>    match = object({<br>      kinds = list(object({<br>        apiGroups = list(string)<br>        kinds     = list(string)<br>      }))<br>      namespaces = list(string)<br>    })<br>    parameters = any<br>  }))</pre> | `[]` | no |
| default\_constraints | Default constraints that should be added | <pre>list(object({<br>    kind               = string<br>    name               = string<br>    enforcement_action = string<br>    match = object({<br>      kinds = list(object({<br>        apiGroups = list(string)<br>        kinds     = list(string)<br>      }))<br>      namespaces = list(string)<br>    })<br>    parameters = any<br>  }))</pre> | <pre>[<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPAllowPrivilegeEscalationContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-allow-privilege-escalation-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNamespace",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-namespace",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNetworkingPorts",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-network-ports",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPFlexVolumes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-flexvolume-drivers",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPPrivilegedContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-privileged-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPProcMount",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-proc-mount",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPReadOnlyRootFilesystem",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-readonlyrootfilesystem",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPVolumeTypes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-volume-types",<br>    "parameters": {<br>      "volumes": [<br>        "configMap",<br>        "downwardAPI",<br>        "emptyDir",<br>        "persistentVolumeClaim",<br>        "secret",<br>        "projected"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPCapabilities",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-capabilities",<br>    "parameters": {<br>      "allowedCapabilities": [<br>        ""<br>      ],<br>      "requiredDropCapabilities": [<br>        "NET_RAW"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sBlockNodePort",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "block-node-port",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sRequiredProbes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "required-probes",<br>    "parameters": {<br>      "probeTypes": [<br>        "tcpSocket",<br>        "httpGet",<br>        "exec"<br>      ],<br>      "probes": [<br>        "readinessProbe"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPodPriorityClass",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "pod-priority-class",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sExternalIPs",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "external-ips",<br>    "parameters": {}<br>  }<br>]</pre> | no |
| exclude | Namespaces to opt out of constraints | <pre>list(object({<br>    excluded_namespaces = list(string)<br>    processes           = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_namespaces": [<br>      "kube-system",<br>      "gatekeeper-system"<br>    ],<br>    "processes": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |
| input\_depends\_on | Input dependency for module | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| output\_depends\_on | Output dependency for module |

