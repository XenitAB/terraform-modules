apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: nginx-gateway-fabric
  namespace: nginx-gateway
spec:
  interval: 1m0s
  type: oci
  url: "oci://ghcr.io/nginxinc/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: nginx-gateway-fabric
  namespace: nginx-gateway
spec:
  chart:
    spec:
      chart: nginx-gateway-fabric
      sourceRef:
        kind: HelmRepository
        name: nginx-gateway-fabric
      version: 1.4.0
  interval: 1m0s
  values:
    nginxGateway:
      config:
        logging:
          level: ${logging_level}
      configAnnotations:
        cert-manager.io/cluster-issuer: letsencrypt
      gatewayClassName: nginx
      gwAPIExperimentalFeatures:
        enable: true
      productTelemetry:
        enable: false
      replicaCount: ${replica_count}
      snippetsFilters:
        enable: true
    nginx:
      ipFamily: dual
      rewriteClientIP: XForwardedFor
      %{~ if telemetry_enabled ~}
      telemetry:
        exporter:
          endpoint: ${telemetry_config.endpoint}
          interval: ${telemetry_config.interval}
          batchSize: ${telemetry_config.batch_size}
          batchCount: ${telemetry_config.batch_count}
      %{~ endif ~}
      logging:
        errorLevel: ${logging_level}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app.kubernetes.io/instance
                      operator: In
                      values:
                        - ingress-nginx
                topologyKey: topology.kubernetes.io/zone
              weight: 100