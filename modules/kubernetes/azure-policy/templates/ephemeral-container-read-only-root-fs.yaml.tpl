apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: ephemeral-container-read-only-root-fs
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
      - cert-manager
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