apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vpa
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "2"
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
    - Replace=true
  source:
    repoURL: https://charts.fairwinds.com/stable
    targetRevision: 1.6.1
    chart: vpa
    helm:
      valuesObject:
        priorityClassName: platform-medium
        recommender:
          image:
            repository: registry.k8s.io/autoscaling/vpa-recommender
            pullPolicy: IfNotPresent
            tag: "0.12.0"
          extraArgs:
            pod-recommendation-min-cpu-millicores: 15
            pod-recommendation-min-memory-mb: 24
          resources:
            limits:
              cpu: 200m
              memory: 500Mi
            requests:
              cpu: 50m
              memory: 250Mi
        updater:
          enabled: false
        admissionController:
          enabled: false