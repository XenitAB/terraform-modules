apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: init-container-disallow-privilege-escalation
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