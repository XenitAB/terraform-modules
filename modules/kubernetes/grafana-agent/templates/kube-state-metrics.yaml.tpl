apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kube-state-metrics
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: grafana-agent
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://prometheus-community.github.io/helm-charts
    targetRevision: v5.18.1
    chart: kube-state-metrics
    helm:
      valuesObject:
        priorityClassName: "platform-low"
        podSecurityPolicy:
          enabled: false
        metricLabelsAllowlist:
          - "namespaces=[xkf.xenit.io/kind]"
        namespaces: ${namespaces_csv}
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
        prometheus:
          monitor:
            enabled: true
            honorLabels: true
            additionalLabels:
              xkf.xenit.io/monitoring: tenant