apiVersion: mutations.gatekeeper.sh/v1beta1
kind: Assign
metadata:
  name: pod-default-seccomp
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
  location: "spec.securityContext.seccompProfile.type"
  parameters:
    assign:
      value: RuntimeDefault
    pathTests:
      - subPath: "spec.securityContext.seccompProfile"
        condition: MustNotExist