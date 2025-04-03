apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kube-prometheus-stack
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: prometheus
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - ServerSideApply=true
  source:
    repoURL: https://prometheus-community.github.io/helm-charts
    targetRevision: 42.1.1
    chart: kube-prometheus-stack
    helm:
      valuesObject:
        # For more values see: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
        # We do not monitor anything in clusters.
        defaultRules:
          create: false
        # Grafana is managed by the grafana-operator
        grafana:
          enabled: false
        kubeControllerManager:
          enabled: false
        kubeScheduler:
          enabled: false
        kubeEtcd:
          enabled: false
        kubeApiServer:
          enabled: true
          serviceMonitor:
            # The API Server generates a lot of metrics which are not useful in a managed Kubernetes cluster.
            # To reduce the metrics stored we dop everything except specific metrics.
            metricRelabelings:
              - action: keep
                regex: "kubernetes_build_info|apiserver_admission_.*"
                sourceLabels: [__name__]
        # Specific for AKS kube-proxy label
        kubeProxy:
          service:
            selector:
              component: kube-proxy
        # We don't use alert manager in the cluster, we use thanos ruler
        alertmanager:
          enabled: false
        prometheus:
          enabled: false
        kube-state-metrics:
          resources:
            requests:
              cpu: 15m
              memory: 50Mi
          priorityClassName: "platform-low"
          podSecurityPolicy:
            enabled: false
          metricLabelsAllowlist:
            - "namespaces=[xkf.xenit.io/kind]"
          collectors:
            # Disable collection of configmaps and secrets to reduce amount of metrics
            #- configmaps
            #- secrets
            - certificatesigningrequests
            - cronjobs
            - daemonsets
            - deployments
            - endpoints
            - horizontalpodautoscalers
            - ingresses
            - jobs
            - limitranges
            - mutatingwebhookconfigurations
            - namespaces
            - networkpolicies
            - nodes
            - persistentvolumeclaims
            - persistentvolumes
            - poddisruptionbudgets
            - pods
            - replicasets
            - replicationcontrollers
            - resourcequotas
            - services
            - statefulsets
            - storageclasses
            - validatingwebhookconfigurations
            - volumeattachments
          # Specificly add verticalpodautoscalers to collectors
          %{ if vpa_enabled }
            - verticalpodautoscalers # not a default resource, see also: https://github.com/kubernetes/kube-state-metrics#enabling-verticalpodautoscalers
          %{ endif }
          prometheus:
            monitor:
              additionalLabels:
                xkf.xenit.io/monitoring: platform
        commonLabels:
          xkf.xenit.io/monitoring: platform
        global:
          rbac:
            pspEnabled: false
        prometheusOperator:
          priorityClassName: "platform-low"
        prometheus-node-exporter:
          priorityClassName: "platform-high"
          prometheus:
            monitor:
              additionalLabels:
                xkf.xenit.io/monitoring: platform