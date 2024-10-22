apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: contour
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: "./platform/${cluster_id}/contour/"
  prune: true
  wait: true
  #healthChecks:
  #- apiVersion: apps/v1
  #  kind: Deployment
  #  namespace: projectcontour
  #  name: 