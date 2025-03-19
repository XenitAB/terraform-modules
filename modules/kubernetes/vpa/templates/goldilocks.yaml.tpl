apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: goldilocks
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: vpa
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
  source:
    repoURL: https://charts.fairwinds.com/stable
    targetRevision: 6.5.1
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