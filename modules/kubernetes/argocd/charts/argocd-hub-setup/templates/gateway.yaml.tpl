apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
  name: argocd-gateway
  namespace: argocd
spec:
  gatewayClassName: eg
  listeners:
    - name: https
      hostname: {{ $global_domain }}
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: argocd-tls
      allowedRoutes:
        namespaces:
          from: All
---
