apiVersion: v1
kind: Namespace
metadata:
 name: gatekeeper-system
 labels:
   name: "gatekeeper-system"
   "admission.gatekeeper.sh/ignore": "no-self-managing"
   "xkf.xenit.io/kind": "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: gatekeeper
  namespace: gatekeeper-system
spec:
  interval: 1m0s
  url: "https://open-policy-agent.github.io/gatekeeper/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: gatekeeper
  namespace: gatekeeper-system
spec:
  chart:
    spec:
      chart: gatekeeper
      sourceRef:
        kind: HelmRepository
        name: gatekeeper
      version: 3.18.2
  interval: 1m0s
  install:
    crds: CreateReplace
  upgrade:
    crds: CreateReplace
  values:
    postInstall:
      labelNamespace:
        enabled: false
      tolerations:
        - key: "kubernetes.azure.com/scalesetpriority"
          operator: "Equal"
          value: "spot"
          effect: "NoSchedule"
    controllerManager:
      priorityClassName: platform-high
      tolerations:
        - key: "kubernetes.azure.com/scalesetpriority"
          operator: "Equal"
          value: "spot"
          effect: "NoSchedule"
    audit:
      priorityClassName: platform-high
      resources:
        limits:
          memory: 750Mi
        requests:
          cpu: 100m
          memory: 256Mi
      tolerations:
        - key: "kubernetes.azure.com/scalesetpriority"
          operator: "Equal"
          value: "spot"
          effect: "NoSchedule"
    psp:
      enabled: false
    upgradeCRDs:
      enabled: false
    mutatingWebhookReinvocationPolicy: IfNeeded
    mutatingWebhookCustomRules:
      - apiGroups:
        - '*'
        apiVersions:
        - '*'
        operations:
        - CREATE
        - UPDATE
        resources:
        - '*'
        - pods/ephemeralcontainers
        scope: '*'
