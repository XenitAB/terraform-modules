apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: nginx-gateway-fabric
  namespace: nginx-gateway
spec:
  interval: 1m0s
  url: "oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric"
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
          level: debug
      gatewayClassName: ngf
      gwAPIExperimentalFeatures:
        enable: true