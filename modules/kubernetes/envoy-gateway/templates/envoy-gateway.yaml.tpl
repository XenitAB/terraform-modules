apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: envoy-gateway
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: envoy-gateway
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
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
 