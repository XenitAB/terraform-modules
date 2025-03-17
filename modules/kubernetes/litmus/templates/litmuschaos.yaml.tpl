apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: litmuschaos
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: litmus
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://litmuschaos.github.io/litmus-helm
    targetRevision: 3.12.0
    chart: litmus
    helm:
      valuesObject:
        #portal:
        #  server:
        #    waitForMongodb:
        #      securityContext:
        #        runAsNonRoot: true
        #        readOnlyRootFilesystem: true