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
        admissionController:
          replicas: ${kyverno_config.admission_controller_replicas}
          priorityClassName: platform-high
          serviceMonitor:
            enabled: false
          webhookAnnotations:
            admissions.enforcer/disabled: "true"
          container:
            resources:
              requests:
                cpu: 100m
                memory: 256Mi
              limits:
                memory: 750Mi
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"

        backgroundController:
          replicas: ${kyverno_config.background_controller_replicas}
          priorityClassName: platform-high
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"

        cleanupController:
          replicas: ${kyverno_config.cleanup_controller_replicas}
          priorityClassName: platform-high
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"

        reportsController:
          replicas: ${kyverno_config.reports_controller_replicas}
          priorityClassName: platform-high
          tolerations:
            - key: "kubernetes.azure.com/scalesetpriority"
              operator: "Equal"
              value: "spot"
              effect: "NoSchedule"

        metricsConfig:
          metricsRefreshInterval: 30s

        config:
          excludeGroups:
            - system:nodes
          excludeNamespaces:
            %{ for ns in exclude_namespaces ~}
  - ${ns}
            %{ endfor }
