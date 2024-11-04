apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: envoy-gateway
  namespace: envoy-gateway
spec:
  interval: 1m0s
  type: oci
  url: "oci://docker.io/envoyproxy/gateway-helm"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: envoy-gateway
  namespace: envoy-gateway
spec:
  chart:
    spec:
      chart: gateway-helm
      sourceRef:
        kind: HelmRepository
        name: envoy-gateway
      version: v0.0.0-latest
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
