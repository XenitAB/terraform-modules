apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: ephemeral-container-disallow-privilege-escalation
spec:
  match:
    excludedNamespaces:
      - calico-system
      - gatekeeper-system
      - kube-system
      - tigera-operator
      - aad-pod-identity
      - cert-manager
      - csi-secrets-store-provider-azure
      - datadog
      - external-dns
      - falco
      - flux-system
      - ingress-nginx
      - prometheus
      - reloader
      - spegel
      - vpa
      %{ for ns in exclude_namespaces }
      - ${ns}
      %{ endfor }
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