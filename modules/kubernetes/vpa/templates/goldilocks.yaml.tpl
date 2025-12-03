apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: goldilocks
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: vpa
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
  source:
    repoURL: https://charts.fairwinds.com/stable
    targetRevision: 10.1.0
    chart: goldilocks
    helm:
      valuesObject:
        dashboard:
          enabled: false
        controller:
          flags:
            on-by-default: "true"
            exclude-namespaces: "kube-system"
          rbac:
            extraRules:
              - apiGroups:
                  - 'batch'
                resources:
                  - '*'
                verbs:
                  - 'get'
                  - 'list'
                  - 'watch'
          resources:
            limits:
              cpu: 100m
              memory: 300Mi
            requests:
              cpu: 60m
              memory: 200Mi