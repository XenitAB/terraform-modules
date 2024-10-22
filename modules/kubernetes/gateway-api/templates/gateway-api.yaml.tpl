apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: gateway-api-crds
  namespace: flux-system
spec:
  interval: 5m0s
  url: https://github.com/kubernetes-sigs/gateway-api/config/crd/experimental?timeout=120&ref=v1.2.0
  ref:
    branch: main