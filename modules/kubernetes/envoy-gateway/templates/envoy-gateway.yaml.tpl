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
        pod-security.kubernetes.io/enforce: restricted
        pod-security.kubernetes.io/audit: restricted
        pod-security.kubernetes.io/warn: restricted
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://docker.io/envoyproxy/gateway-helm
    chart: v1.6.3
    helm:
      valuesObject:
        config:
          envoyGateway:
            logging:
              level:
                default: ${envoy_gateway_config.logging_level}
            gateway:
              controllerName: gateway.envoyproxy.io/gatewayclass-controller
            provider:
              type: Kubernetes
              kubernetes:
                # Security Context for Envoy Proxy pods
                envoyDeployment:
                  pod:
                    securityContext:
                      runAsNonRoot: true
                      runAsUser: 65534
                      runAsGroup: 65534
                      fsGroup: 65534
                      seccompProfile:
                        type: RuntimeDefault
                    annotations:
                      prometheus.io/scrape: "true"
                      prometheus.io/port: "19001"
                  container:
                    securityContext:
                      allowPrivilegeEscalation: false
                      runAsNonRoot: true
                      runAsUser: 65534
                      capabilities:
                        drop:
                          - ALL
                        add:
                          - NET_BIND_SERVICE
                      readOnlyRootFilesystem: true
                    resources:
                      limits:
                        cpu: ${envoy_gateway_config.proxy_cpu_limit}
                        memory: ${envoy_gateway_config.proxy_memory_limit}
                      requests:
                        cpu: ${envoy_gateway_config.proxy_cpu_requests}
                        memory: ${envoy_gateway_config.proxy_memory_requests}
                    env:
                      # Limit per-connection buffer sizes to prevent memory exhaustion
                      - name: ENVOY_OVERLOAD_MANAGER_ENABLED
                        value: "true"
        deployment:
          replicas: ${envoy_gateway_config.replicas_count}
          envoyGateway:
            # Security Context for Envoy Gateway controller
            podSecurityContext:
              runAsNonRoot: true
              runAsUser: 65532
              runAsGroup: 65532
              fsGroup: 65532
              seccompProfile:
                type: RuntimeDefault
            securityContext:
              allowPrivilegeEscalation: false
              runAsNonRoot: true
              runAsUser: 65532
              capabilities:
                drop:
                  - ALL
              readOnlyRootFilesystem: true
            resources:
              limits:
                cpu: ${envoy_gateway_config.resources_cpu_limit}
                memory: ${envoy_gateway_config.resources_memory_limit}
              requests:
                cpu: ${envoy_gateway_config.resources_cpu_requests}
                memory: ${envoy_gateway_config.resources_memory_requests}
        podDisruptionBudget:
          minAvailable: 1
 