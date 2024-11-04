apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: OCIRepository
metadata:
  name: envoy-gateway
  namespace: envoy-gateway
spec:
  interval: 1m0s
  url: "oci://docker.io/envoyproxy/gateway-helm"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: envoy-gateway
  namespace: envoy-gateway
spec:
  chartRef:
    kind: OCIRepository
    name: envoy-gateway
    namespace: envoy-gateway
  interval: 1m0s
  values:
    config:
      envoyGateway:
        logging:
          level:
            default: ${envoy_gateway_config.logging_level}
    deployment:
      pod:
        labels: ${envoy_gateway_config.pod_labels}
      replicas: ${envoy_gateway_config.replicas_count}
      envoyGateway:
        resources:
          limits:
            memory: ${envoy_gateway_config.resources_memory_limit}
          requests:
            cpu: ${envoy_gateway_config.resources_cpu_requests}
            memory: ${envoy_gateway_config.resources_memory_requests}
    service:
      annotations: ${envoy_gateway_config.service_annotations}
