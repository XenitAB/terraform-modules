apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: gateway-api
  namespace: flux-system
spec:
  interval: 5m
  resources:
  - https://github.com/kubernetes-sigs/gateway-api/config/crd/experimental?timeout=120&ref=v1.2.0
  path: "./platform/${cluster_id}/gateway-api/"