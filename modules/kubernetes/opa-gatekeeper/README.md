# Open Policy Agent Gatekeeper (opa-gatekeeper)

This module is used to add [`opa-gatekeeper`](https://github.com/open-policy-agent/gatekeeper) to Kubernetes clusters.

## Details

This module also adds opinionated defaults from the [`gatekeeper-library`](https://github.com/XenitAB/gatekeeper-library) that Xenit hosts (and aggregates the [`gatekeeper-library`](https://github.com/open-policy-agent/gatekeeper-library) OPA hosts).

## Example deployment

```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: podinfo
  labels:
    app: podinfo
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      app: podinfo
  template:
    metadata:
      labels:
        app: podinfo
    spec:
      terminationGracePeriodSeconds: 30
      containers:
        - name: podinfo
          image: "ghcr.io/stefanprodan/podinfo:5.0.3"
          imagePullPolicy: "IfNotPresent"
          command:
            - ./podinfo
            - --port=8080
            - --level=info
          env:
          - name: PODINFO_UI_MESSAGE
            value: "WELCOME TO PODINFO!"
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          readinessProbe:
            exec:
              command:
              - podcli
              - check
              - http
              - localhost:8080/readyz
            initialDelaySeconds: 1
            timeoutSeconds: 5
          volumeMounts:
          - name: data
            mountPath: /data
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - NET_RAW
      volumes:
      - name: data
        emptyDir: {}
```

Required parts are `securityContext` and usually mounting an `emptyDir` to either a data directory or tmp.

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
| default\_constraints | Default constraints that should be added | <pre>list(object({<br>    kind               = string<br>    name               = string<br>    enforcement_action = string<br>    match = object({<br>      kinds = list(object({<br>        apiGroups = list(string)<br>        kinds     = list(string)<br>      }))<br>      namespaces = list(string)<br>    })<br>    parameters = any<br>  }))</pre> | <pre>[<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPAllowPrivilegeEscalationContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-allow-privilege-escalation-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNamespace",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-namespace",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPHostNetworkingPorts",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-host-network-ports",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPFlexVolumes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-flexvolume-drivers",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPPrivilegedContainer",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-privileged-container",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPProcMount",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-proc-mount",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPReadOnlyRootFilesystem",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-readonlyrootfilesystem",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPVolumeTypes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-volume-types",<br>    "parameters": {<br>      "volumes": [<br>        "configMap",<br>        "downwardAPI",<br>        "emptyDir",<br>        "persistentVolumeClaim",<br>        "secret",<br>        "projected"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPSPCapabilities",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "psp-capabilities",<br>    "parameters": {<br>      "allowedCapabilities": [<br>        ""<br>      ],<br>      "requiredDropCapabilities": [<br>        "NET_RAW"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sBlockNodePort",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "block-node-port",<br>    "parameters": {}<br>  },<br>  {<br>    "enforcement_action": "dryrun",<br>    "kind": "K8sRequiredProbes",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "required-probes",<br>    "parameters": {<br>      "probeTypes": [<br>        "tcpSocket",<br>        "httpGet",<br>        "exec"<br>      ],<br>      "probes": [<br>        "readinessProbe"<br>      ]<br>    }<br>  },<br>  {<br>    "enforcement_action": "",<br>    "kind": "K8sPodPriorityClass",<br>    "match": {<br>      "kinds": [],<br>      "namespaces": []<br>    },<br>    "name": "pod-priority-class",<br>    "parameters": {}<br>  }<br>]</pre> | no |
| exclude | Namespaces to opt out of constraints | <pre>list(object({<br>    excluded_namespaces = list(string)<br>    processes           = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_namespaces": [<br>      "kube-system",<br>      "gatekeeper-system"<br>    ],<br>    "processes": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |

## Outputs

No output.

