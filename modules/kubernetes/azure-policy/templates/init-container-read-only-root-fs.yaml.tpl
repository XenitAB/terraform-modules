apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: init-container-read-only-root-fs
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
  location: "spec.initContainers[name:*].securityContext.readOnlyRootFilesystem"
  parameters:
    assign:
      value: true
    pathTests:
    - subPath: "spec.initContainers[name:*].securityContext.readOnlyRootFilesystem"
      condition: MustNotExist