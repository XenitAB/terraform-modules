apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: actions-runner-controller
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: ${arc_config.namespace}
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
    - ServerSideApply=true
  source:
    repoURL: ghcr.io/actions/actions-runner-controller-charts
    targetRevision: ${arc_config.chart_version}
    chart: gha-runner-scale-set-controller
    helm:
      valuesObject:
        replicaCount: ${arc_config.replica_count}
        %{~ if arc_config.watch_single_namespace != "" ~}
        flags:
          watchSingleNamespace: ${arc_config.watch_single_namespace}
        %{~ endif ~}
        serviceAccount:
          create: true
          name: ${service_account_name}
        resources:
          requests:
            cpu: ${arc_config.resources_cpu_requests}
            memory: ${arc_config.resources_memory_requests}
          limits:
            memory: ${arc_config.resources_memory_limit}
        tolerations:
          - key: "kubernetes.azure.com/scalesetpriority"
            operator: "Equal"
            value: "spot"
            effect: "NoSchedule"
