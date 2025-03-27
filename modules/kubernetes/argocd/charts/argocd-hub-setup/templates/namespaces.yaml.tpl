{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}
  labels:
    xkf.xenit.io/kind: platform
  selfLink: /api/v1/namespaces/argocd
spec:
  finalizers:
    - kubernetes
---
{{- end }}
{{- end }}