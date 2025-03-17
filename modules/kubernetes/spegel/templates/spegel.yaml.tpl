apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: spegel
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: spegel
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: oci://ghcr.io/spegel-org/helm-charts
    targetRevision: v0.0.30
    chart: spegel
    helm:
      valuesObject:
        resources:
          requests:
            cpu: 15m
            memory: 40Mi
          limits:
            memory: 140Mi
        spegel:
          mirrorResolveTimeout: "1s"
          registries:
            - https://cgr.dev
            - https://docker.io
            - https://ghcr.io
            - https://quay.io
            - https://mcr.microsoft.com
            - https://gcr.io
            - https://registry.k8s.io
            - https://k8s.gcr.io
            - https://lscr.io
            %{~ if private_registry != "" ~}
            - ${ private_registry }
            %{~ endif ~}
