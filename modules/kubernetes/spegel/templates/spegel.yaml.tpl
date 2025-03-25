apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: spegel
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: spegel
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ghcr.io/spegel-org/helm-charts
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
