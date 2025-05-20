{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ printf "%s-%s" $azure_tenant.tenant_name $cluster.environment }}
  labels:
    xkf.xenit.io/kind: platform
spec:
  finalizers:
    - kubernetes
---
{{- end }}
{{- end }}