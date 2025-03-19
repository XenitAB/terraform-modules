apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-gateway-fabric
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: nginx-gateway
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://ghcr.io/nginxinc/charts
    targetRevision: 1.4.0
    chart: nginx-gateway-fabric
    helm:
      valuesObject:
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