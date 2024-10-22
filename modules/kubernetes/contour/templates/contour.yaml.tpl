apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: contour
  namespace: projectcontour
spec:
  interval: 1m0s
  url: "https://charts.bitnami.com/bitnami"
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: contour
  namespace: projectcontour
spec:
  chart:
    spec:
      chart: contour
      sourceRef:
        kind: HelmRepository
        name: contour
      version: 19.2.0
  interval: 1m0s
  values:
    contour:
      replicaCount: ${contour_config.replica_count}
      priorityClassName: "platform-high"
      resourcesPreset: ${contour_config.resource_preset}
      podAntiAffinityPreset: "hard"
      pdb:
        create: true
        minAvailable: "1"
      envoy:
        kind: deployment
        replicaCount: ${envoy_config.replica_count}
        priorityClassName: "platform-high"
        resourcesPreset: ${envoy_config.resource_preset}
        %{~ if envoy_config.hpa_enabled ~}
        autoscaling:
          enabled: true
          minReplicas: 1
          maxReplicas: ${hpa_config.max_replicas}
          %{~ if hpa_config.maz_cpu != null ~}
          targetCPU: "${hpa_config.max_cpu}"
          %{~ endif ~}
          %{~ if hpa_config.target_memory != null ~}
          targetMemory: "${hpa_config.target_memory}"
          %{~ endif ~}
          %{~ if hpa_config.behavior != null ~}
          behavior:
            ${hpa_config.behavior}
          %{~ endif ~}
        %{~ endif ~}
        podAntiAffinityPreset: "hard"
        logLevel: ${envoy_config.log_level}
      ingress:
        enabled: ${contour_config.ingress_enabled}
        certManager: true