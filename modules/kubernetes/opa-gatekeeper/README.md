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
| default\_constraints | Default constraints that should be added | <pre>list(object({<br>    kind               = string<br>    name               = string<br>    enforcement_action = string<br>    match = object({<br>      kinds = list(object({<br>        apiGroups = list(string)<br>        kinds     = list(string)<br>      }))<br>      namespaces = list(string)<br>    })<br>    parameters = any<br>  }))</pre> | <pre>[<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPAllowPrivilegeEscalationContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-allow-privilege-escalation-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNamespace",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-namespace",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNetworkingPorts",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-network-ports",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPFlexVolumes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-flexvolume-drivers",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPPrivilegedContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-privileged-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPProcMount",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-proc-mount",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPReadOnlyRootFilesystem",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-readonlyrootfilesystem",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPVolumeTypes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-volume-types",<br>    "parameters": {<br>      "volumes": [<br>        "configMap",<br>        "downwardAPI",<br>        "emptyDir",<br>        "persistentVolumeClaim",<br>        "secret",<br>        "projected"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPCapabilities",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-capabilities",<br>    "parameters": {<br>      "allowedCapabilities": [<br>        ""<br>      ],<br>      "requiredDropCapabilities": [<br>        "NET_RAW"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sBlockNodePort",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "block-node-port",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sRequiredProbes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "required-probes",<br>    "parameters": {<br>      "probeTypes": [<br>        "tcpSocket",<br>        "httpGet",<br>        "exec"<br>      ],<br>      "probes": [<br>        "readinessProbe"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPodPriorityClass",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "pod-priority-class",<br>    "parameters": {}<br>  }<br>]</pre> | no |
| exclude | Namespaces to opt out of constraints | <pre>list(object({<br>    excluded_namespaces = list(string)<br>    processes           = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_namespaces": [<br>      "kube-system",<br>      "gatekeeper-system"<br>    ],<br>    "processes": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |

## Outputs

No output.

