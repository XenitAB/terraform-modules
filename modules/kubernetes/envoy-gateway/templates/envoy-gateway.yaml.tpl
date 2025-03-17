apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: envoy-gateway
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: envoy-gateway
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://docker.io/envoyproxy
    targetRevision: v0.0.0-latest
    chart: gateway-helm
    helm:
      valuesObject:
        config:
          envoyGateway:
            logging:
              level:
                default: ${envoy_gateway_config.logging_level}
        deployment:
          replicas: ${envoy_gateway_config.replicas_count}
          envoyGateway:
            resources:
              limits:
                memory: ${envoy_gateway_config.resources_memory_limit}
              requests:
                cpu: ${envoy_gateway_config.resources_cpu_requests}
                memory: ${envoy_gateway_config.resources_memory_requests}
 