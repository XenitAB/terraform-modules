{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
{{- range .tenants }}
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: '{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}-{{- .name -}}'
spec:
  # Allow manifests to deploy from specific repository (url) only
  sourceRepos:
  - '{{- .repo_url -}}'
  # Only permit applications to deploy to these namespace in the same cluster
  destinations:
  - namespace: '{{- .namespace -}}'
    server: '{{- $cluster.api_server -}}'
---
{{- end }}
{{- end }}
{{- end }}