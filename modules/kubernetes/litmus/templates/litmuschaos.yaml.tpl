apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: litmuschaos
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: litmus
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
    repoURL: https://litmuschaos.github.io/litmus-helm
    targetRevision: 3.23.0
    chart: litmus
    #helm:
      #valuesObject:
        #portal:
        #  server:
        #    waitForMongodb:
        #      securityContext:
        #        runAsNonRoot: true
        #        readOnlyRootFilesystem: true