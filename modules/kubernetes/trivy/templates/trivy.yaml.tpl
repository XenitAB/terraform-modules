apiVersion: v1
kind: Namespace
metadata:
 name: trivy
 labels:
   name: trivy
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: trivy
  namespace: trivy
spec:
  interval: 1m0s
  url: "https://aquasecurity.github.io/helm-charts/"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: trivy
  namespace: trivy
spec:
  chart:
    spec:
      chart: trivy
      sourceRef:
        kind: HelmRepository
        name: trivy
      version: v0.11.0
  interval: 1m0s
  values:
    trivy:
      labels:
        azure.workload.identity/use: "true"
      serviceAccount:
        annotations:
          azure.workload.identity/client-id: ${client_id}
    persistence:
      storageClass: ${volume_claim_storage_class_name}
