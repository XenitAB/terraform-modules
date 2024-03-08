apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: container-drop-capabilities
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
      - trivy
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
  location: "spec.containers[name:*].securityContext.capabilities.drop"
  parameters:
    assign:
      value:        
        - NET_RAW
        - CAP_SYS_ADMIN
    pathTests:
    - subPath: "spec.containers[name:*].securityContext.capabilities"
      condition: MustNotExist