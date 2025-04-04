{{- $sync_windows := .Values.sync_windows }}
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
  # Allow Application resources to deploy only into these namespaces
  sourceNamespaces:
  - 'argocd'
  - '{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}'
  # Allow manifests to deploy from specific repository (url) only
  sourceRepos:
  #- '{{- .repo_url -}}'
  - '*'
  # Only permit applications to deploy to these namespace in the given cluster
  destinations:
  - namespace: 'argocd'
    server: https://kubernetes.default.svc
  - namespace: '{{- $azure_tenant.tenant_name -}}-{{- $cluster.environment -}}'
    server: https://kubernetes.default.svc
  - namespace: '{{- .namespace -}}'
    server: '{{- $cluster.api_server -}}'
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  #{{- if .Values.sync_windows }}
  syncWindows:
  {{- range $sync_windows }}
  - kind: {{- .kind | quote }}
    schedule: {{- .schedule | quote }}
    duration: {{- .duration | quote }}
    manualSync: {{- .manual_sync }}
  {{- end }}
  #{{- end }}
---
{{- end }}
{{- end }}
{{- end }}