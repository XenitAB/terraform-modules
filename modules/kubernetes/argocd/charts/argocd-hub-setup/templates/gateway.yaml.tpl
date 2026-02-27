apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
  name: argocd-gateway
  namespace: argocd
spec:
  gatewayClassName: {{ printf "%s-%s" .Values.tenant_name .Values.environment }}
  listeners:
    - name: https
      hostname: {{ required "global_domain must be set" .Values.global_domain | quote }}
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
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: ClientTrafficPolicy
metadata:
  name: preserve-escaped-slashes
  namespace: argocd
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: Gateway
    name: argocd-gateway
  path:
    escapedSlashesAction: KeepUnchanged
    disableMergeSlashes: true
---