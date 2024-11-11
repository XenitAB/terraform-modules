apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
  labels:
    name: ingress-nginx
    xkf.xenit.io/kind: platform
  annotations:
    kustomize.toolkit.fluxcd.io/prune: Disabled