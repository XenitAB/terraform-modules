apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: nginx-gateway
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/nginx-gateway-fabric/"
  prune: true
  wait: true
  #healthChecks:
  #- apiVersion: apps/v1
  #  kind: Deployment
  #  namespace: ingress-nginx
  #  name: ingress-nginx-controller