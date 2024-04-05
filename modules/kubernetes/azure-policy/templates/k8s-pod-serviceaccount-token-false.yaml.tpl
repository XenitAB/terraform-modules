apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: pod-serviceaccount-token-false
spec:
  match:
    namespaceSelector:
      matchLabels:
        xkf.xenit.io/kind: tenant
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