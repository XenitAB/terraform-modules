---
# GatewayClass - Defines the controller that will manage Gateway resources
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
  description: "${tenant_name} ${environment} gateway class managed by Xenit
