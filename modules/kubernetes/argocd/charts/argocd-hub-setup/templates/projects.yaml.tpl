{{- $sync_windows := .Values.sync_windows }}
{{- range .Values.azure_tenants }}
{{- $azure_tenant := . }}
{{- range .clusters }}
{{- $cluster := . }}
{{- range .tenants }}
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: {{ printf "%s-%s-%s" $azure_tenant.tenant_name $cluster.environment .name }}
spec:
  # Allow Application resources to deploy only into these namespaces
  sourceNamespaces:
  - "argocd"
  - {{ printf "%s-%s" $azure_tenant.tenant_name $cluster.environment | quote }}
  # Allow manifests to deploy from specific repository (url) only
  sourceRepos:
  #- '{{- .repo_url -}}'
  - "*"
  # Only permit applications to deploy to these namespace in the given cluster
  destinations:
  - namespace: "argocd"
    server: "https://kubernetes.default.svc"
  - namespace: {{ printf "%s-%s" $azure_tenant.tenant_name $cluster.environment | quote }}
    server: "https://kubernetes.default.svc"
  - namespace: {{ .namespace | quote }}
    server: {{ $cluster.api_server | quote }}
  clusterResourceWhitelist:
  - group: "*"
    kind: "*"
  syncWindows:
  {{- range $sync_windows }}
  - kind: {{ .kind | quote }}
    schedule: {{ .schedule | quote }}
    timeZone: "Europe/Stockholm"
    duration: {{ .duration | quote }}
    manualSync: {{ .manual_sync }}
  {{- end }}
---
{{- end }}
{{- end }}
{{- end }}