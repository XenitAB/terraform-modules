apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: gateway-api-crds
  namespace: flux-system
spec:
  interval: 5m
  url: https://github.com/kubernetes-sigs/gateway-api
  ref:
    tag: ${api_version}
  ignore: |
    # exclude all
    /*
    # include crd dir
    !/config/crd/${api_channel}
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: gateway-api
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: gateway-api-crds
    namespace: flux-system
  path: "./config/crd/${api_channel}"
  prune: true