apiVersion: v1
kind: Namespace
metadata:
 name: vpa
 labels:
   name              = "vpa"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: fairwinds
  namespace: vpa
spec:
  interval: 1m0s
  url: "https://charts.fairwinds.com/stable"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: vpa
  namespace: vpa
spec:
  chart:
    spec:
      chart: vpa
      sourceRef:
        kind: HelmRepository
        name: fairwinds
      version: 1.6.1
  interval: 1m0s
  install:
    crds: CreateReplace
  upgrade:
    crds: CreateReplace
  values:
    priorityClassName: platform-medium
    recommender:
      image:
        repository: registry.k8s.io/autoscaling/vpa-recommender
        pullPolicy: IfNotPresent
        tag: "0.12.0"
      extraArgs:
        pod-recommendation-min-cpu-millicores: 15
        pod-recommendation-min-memory-mb: 24
      resources:
        limits:
          cpu: 200m
          memory: 500Mi
        requests:
          cpu: 50m
          memory: 250Mi
    updater:
      enabled: false
    admissionController:
      enabled: false
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: goldilocks
  namespace: vpa
spec:
  chart:
    spec:
      chart: goldilocks
      sourceRef:
        kind: HelmRepository
        name: fairwinds
      version: 6.5.1
  interval: 1m0s
  values:
    dashboard:
      enabled: false
    controller:
      flags:
        on-by-default: "true"
        exclude-namespaces: "kube-system"
      rbac:
        extraRules:
          - apiGroups:
              - 'batch'
            resources:
              - '*'
            verbs:
              - 'get'
              - 'list'
              - 'watch'
      resources:
        limits:
          cpu: 100m
          memory: 300Mi
        requests:
          cpu: 60m
          memory: 200Mi
