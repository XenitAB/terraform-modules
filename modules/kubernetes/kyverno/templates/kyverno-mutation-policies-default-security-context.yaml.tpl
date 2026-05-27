apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: default-security-context
  annotations:
    policies.kyverno.io/title: Default Security Context
    policies.kyverno.io/category: Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/description: >-
      Sets secure defaults for pod and container security contexts when not already specified.
      Equivalent to gatekeeper Assign mutations for allowPrivilegeEscalation, readOnlyRootFilesystem,
      capabilities drop, seccompProfile, and automountServiceAccountToken.
spec:
  background: true
  rules:
  - name: default-allow-privilege-escalation
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
          %{ if mirrord_enabled }
      - resources:
          annotations:
            operator.metalbear.co/owner: "*"
          %{ endif }
    mutate:
      patchStrategicMerge:
        spec:
          containers:
          - (name): "*"
            securityContext:
              +(allowPrivilegeEscalation): false
          initContainers:
          - (name): "*"
            securityContext:
              +(allowPrivilegeEscalation): false
          ephemeralContainers:
          - (name): "*"
            securityContext:
              +(allowPrivilegeEscalation): false
  - name: default-read-only-root-filesystem
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
          %{ if mirrord_enabled }
      - resources:
          annotations:
            operator.metalbear.co/owner: "*"
          %{ endif }
    mutate:
      patchStrategicMerge:
        spec:
          containers:
          - (name): "*"
            securityContext:
              +(readOnlyRootFilesystem): true
          initContainers:
          - (name): "*"
            securityContext:
              +(readOnlyRootFilesystem): true
          ephemeralContainers:
          - (name): "*"
            securityContext:
              +(readOnlyRootFilesystem): true
  - name: default-drop-capabilities
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
          %{ if mirrord_enabled }
      - resources:
          annotations:
            operator.metalbear.co/owner: "*"
          %{ endif }
    mutate:
      patchStrategicMerge:
        spec:
          containers:
          - (name): "*"
            securityContext:
              capabilities:
                +(drop):
                - NET_RAW
                - CAP_SYS_ADMIN
          initContainers:
          - (name): "*"
            securityContext:
              capabilities:
                +(drop):
                - NET_RAW
                - CAP_SYS_ADMIN
          ephemeralContainers:
          - (name): "*"
            securityContext:
              capabilities:
                +(drop):
                - NET_RAW
                - CAP_SYS_ADMIN
  - name: default-seccomp-profile
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
          %{ if mirrord_enabled }
      - resources:
          annotations:
            operator.metalbear.co/owner: "*"
          %{ endif }
    mutate:
      patchStrategicMerge:
        spec:
          +(securityContext):
            seccompProfile:
              type: RuntimeDefault
  - name: default-automount-service-account-token
    match:
      any:
      - resources:
          kinds:
          - Pod
    exclude:
      any:
      - resources:
          namespaces:
          %{ for ns in exclude_namespaces ~}
  - ${ns}
          %{ endfor }
          %{ if mirrord_enabled }
      - resources:
          annotations:
            operator.metalbear.co/owner: "*"
          %{ endif }
    mutate:
      patchStrategicMerge:
        spec:
          +(automountServiceAccountToken): false
