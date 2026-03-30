apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kyverno
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
    namespace: kyverno
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
    repoURL: https://kyverno.github.io/kyverno/
    chart: kyverno
    targetRevision: 3.7.1
    helm:
      releaseName: kyverno
      valuesObject:
        replicaCount: ${kyverno_config.admission_controller_replicas}

        admissionController:
          replicas: ${kyverno_config.admission_controller_replicas}
          serviceMonitor:
            enabled: false #check why this is here
          webhookAnnotations:
            admissions.enforcer/disabled: "true" #check why this is here

        backgroundController:
          replicas: ${kyverno_config.background_controller_replicas}

        cleanupController:
          replicas: ${kyverno_config.cleanup_controller_replicas}

        reportsController:
          replicas: ${kyverno_config.reports_controller_replicas}

        metricsConfig:
          metricsRefreshInterval: 30s

        config:
          excludeGroups:
            - system:nodes
          excludeNamespaces:
            %{ for ns in exclude_namespaces ~}
  - ${ns}
            %{ endfor }
