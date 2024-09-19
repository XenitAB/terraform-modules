apiVersion: config.gatekeeper.sh/v1alpha1
kind: Config
metadata:
  name: config
  namespace: gatekeeper-system
spec:
  match:
  - excludedNamespaces:
    - kube-system
    - gatekeeper-system
    processes:
    - '*'
  - excludedNamespaces:
    %{ for ns in exclude_namespaces ~}
    - ${ns}
    %{ endfor }
    processes:
    - webhook
    - mutation-webhook
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: ModifySet
metadata:
  name: remove-azure-node-spot-taints
spec:
  location: "spec.taints"
  applyTo:
    - groups: [""]
      kinds: ["Node"]
      versions: ["v1"]
  parameters:
    operation: prune
    values:
      fromList:
        - effect: NoSchedule
          key: kubernetes.azure.com/scalesetpriority
          value: spot
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sBlockNodePort
metadata:
  name: block-node-port
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Service
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: SecretsStoreCSIUniqueVolume
metadata:
  name: unique-volume
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPReadOnlyRootFilesystemXenit
metadata:
  name: psp-readonlyrootfilesystemxenit
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  %{ if mirrord_enabled }
  parameters:
    exemptImages:
    - "ghcr.io/metalbear-co/mirrord:*"
  %{ endif }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPFlexVolumes
metadata:
  name: psp-flexvolume-drivers
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: FluxRequireServiceAccount
metadata:
  name: require-service-account
spec:
  enforcementAction: deny
  match:
    excludedNamespaces:
    - ambassador
    - flux-system
    kinds:
    - apiGroups:
      - helm.toolkit.fluxcd.io
      kinds:
      - HelmRelease
    - apiGroups:
      - kustomize.toolkit.fluxcd.io
      kinds:
      - Kustomization
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPodPriorityClass
metadata:
  name: pod-priority-class
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  parameters:
    permittedClassNames:
    - platform-high
    - platform-medium
    - platform-low
    - tenant-high
    - tenant-medium
    - tenant-low
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPProcMount
metadata:
  name: psp-proc-mount
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequireIngressClass
metadata:
  name: k8srequireingressclass
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - networking.k8s.io
      kinds:
      - Ingress
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPAllowPrivilegeEscalationContainer
metadata:
  name: psp-allow-privilege-escalation-container
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPHostNamespace
metadata:
  name: psp-host-namespace
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  %{ if mirrord_enabled }
  parameters:
    exemptImages:
    - "ghcr.io/metalbear-co/mirrord:*"
  %{ endif }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sExternalIPs
metadata:
  name: external-ips
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Service
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPHostNetworkingPorts
metadata:
  name: psp-host-network-ports
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: FluxDisableCrossNamespaceSource
metadata:
  name: disable-cross-namespace-source
spec:
  enforcementAction: deny
  match:
    excludedNamespaces:
    - flux-system
    kinds:
    - apiGroups:
      - helm.toolkit.fluxcd.io
      kinds:
      - HelmRelease
    - apiGroups:
      - kustomize.toolkit.fluxcd.io
      kinds:
      - Kustomization
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: AzureIdentityFormat
metadata:
  name: azure-identity-format
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - aadpodidentity.k8s.io
      kinds:
      - AzureIdentity
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
    - csi
    %{ if mirrord_enabled }
    exemptImages:
    - "ghcr.io/metalbear-co/mirrord:*"
    %{ endif }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPPrivilegedContainer
metadata:
  name: psp-privileged-container
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPCapabilities
metadata:
  name: psp-capabilities
spec:
  enforcementAction: deny
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  parameters:
    allowedCapabilities:
    - ""
    requiredDropCapabilities:
    - NET_RAW
    - CAP_SYS_ADMIN
    %{ if mirrord_enabled || telepresence_enabled }
    exemptImages:
    %{ if mirrord_enabled }
    - "ghcr.io/metalbear-co/mirrord:*"
    %{ endif }
    %{ if telepresence_enabled }
    - "docker.io/datawire/tel2:*"
    %{ endif }
    %{ endif }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredProbes
metadata:
  name: required-probes
spec:
  enforcementAction: dryrun
  match:
    kinds:
    - apiGroups:
      - ""
      kinds:
      - Pod
  parameters:
    probeTypes:
    - tcpSocket
    - httpGet
    - exec
    probes:
    - readinessProbe
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: container-disallow-privilege-escalation
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - versions: ["v1"]
      groups: [""]
      kinds: ["Pod"]
  location: "spec.containers[name:*].securityContext.allowPrivilegeEscalation"
  parameters:
    assign:
      value: false
    pathTests:
    - subPath: "spec.containers[name:*].securityContext.allowPrivilegeEscalation"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: container-drop-capabilities
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.containers[name:*].securityContext.capabilities.drop"
  parameters:
    assign:
      value:
        - NET_RAW
        - CAP_SYS_ADMIN
    pathTests:
    - subPath: "spec.containers[name:*].securityContext.capabilities"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: container-read-only-root-fs
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.containers[name:*].securityContext.readOnlyRootFilesystem"
  parameters:
    assign:
      value: true
    pathTests:
    - subPath: "spec.containers[name:*].securityContext.readOnlyRootFilesystem"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: ephemeral-container-disallow-privilege-escalation
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - versions: ["v1"]
      groups: [""]
      kinds: ["Pod"]
  location: "spec.ephemeralContainers[name:*].securityContext.allowPrivilegeEscalation"
  parameters:
    assign:
      value: false
    pathTests:
    - subPath: "spec.ephemeralContainers[name:*].securityContext.allowPrivilegeEscalation"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: ephemeral-container-drop-capabilities
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.ephemeralContainers[name:*].securityContext.capabilities.drop"
  parameters:
    assign:
      value:
        - NET_RAW
        - CAP_SYS_ADMIN
    pathTests:
    - subPath: "spec.ephemeralContainers[name:*].securityContext.capabilities"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: ephemeral-container-read-only-root-fs
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.ephemeralContainers[name:*].securityContext.readOnlyRootFilesystem"
  parameters:
    assign:
      value: true
    pathTests:
    - subPath: "spec.ephemeralContainers[name:*].securityContext.readOnlyRootFilesystem"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: init-container-disallow-privilege-escalation
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - versions: ["v1"]
      groups: [""]
      kinds: ["Pod"]
  location: "spec.initContainers[name:*].securityContext.allowPrivilegeEscalation"
  parameters:
    assign:
      value: false
    pathTests:
    - subPath: "spec.initContainers[name:*].securityContext.allowPrivilegeEscalation"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: init-container-drop-capabilities
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.initContainers[name:*].securityContext.capabilities.drop"
  parameters:
    assign:
      value:
        - NET_RAW
        - CAP_SYS_ADMIN
    pathTests:
    - subPath: "spec.initContainers[name:*].securityContext.capabilities"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: init-container-read-only-root-fs
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - groups: [""]
      versions: ["v1"]
      kinds: ["Pod"]
  location: "spec.initContainers[name:*].securityContext.readOnlyRootFilesystem"
  parameters:
    assign:
      value: true
    pathTests:
    - subPath: "spec.initContainers[name:*].securityContext.readOnlyRootFilesystem"
      condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: pod-default-seccomp
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - versions: ["v1"]
      groups: [""]
      kinds: ["Pod"]
  location: "spec.securityContext.seccompProfile.type"
  parameters:
    assign:
      value: RuntimeDefault
    pathTests:
      - subPath: "spec.securityContext.seccompProfile"
        condition: MustNotExist
---
apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: pod-serviceaccount-token-false
spec:
  match:
    scope: Namespaced
    kinds:
      - apiGroups: ["*"]
        kinds: ["Pod"]
  applyTo:
    - versions: ["v1"]
      groups: [""]
      kinds: ["Pod"]
  location: "spec.automountServiceAccountToken"
  parameters:
    assign:
      value: false
    pathTests:
      - subPath: "spec.automountServiceAccountToken"
        condition: MustNotExist
