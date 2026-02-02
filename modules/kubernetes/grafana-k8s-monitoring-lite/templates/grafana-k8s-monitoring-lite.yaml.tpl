apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-k8s-monitoring-lite
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
    namespace: grafana-k8s-monitoring-lite
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
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: 3.7.5
    chart: k8s-monitoring
    helm:
      valuesObject:
        global:
          scrapeInterval: "300s"
        cluster:
          name: "${cluster_name}"
        destinations:
          - name: xenitsweden-prom
            type: prometheus
            url: https://prometheus-prod-39-prod-eu-north-0.grafana.net/api/prom/push
            auth:
              type: basic
              usernameKey: username
              passwordKey: password
            secret:
              create: false
              name: prometheus-grafana-cloud
              namespace: grafana-k8s-monitoring-lite
            tls:
              insecureSkipVerify: false
        clusterMetrics:
          enabled: true
          kube-state-metrics:
            deploy: true
            podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
          node-exporter:
            deploy: false
          windows-exporter:
            deploy: false
          kubelet:
            enabled: true
          cadvisor:
            enabled: true
          apiServer:
            enabled: false
          kubeletResource:
            enabled: true
          kubeControllerManager:
            enabled: false
          kubeProxy:
            enabled: false
          kubeScheduler:
            enabled: false
        clusterEvents:
          enabled: false
        podLogs:
          enabled: false
        applicationObservability:
          enabled: false
        annotationAutodiscovery:
          enabled: false
        prometheusOperatorObjects:
          enabled: false
        alloy-metrics:
          enabled: true
          alloy:
            storagePath: /var/lib/alloy
            mounts:
              extra:
                - name: secret-store
                  mountPath: "/mnt/secrets-store"
                  readOnly: true
          controller:
            replicas: 1
            podAnnotations: {kubernetes.azure.com/set-kube-service-host-fqdn: "true"}
            volumes:
              extra:
                - name: secret-store
                  csi:
                    driver: secrets-store.csi.k8s.io
                    readOnly: true
                    volumeAttributes:
                      secretProviderClass: grafana-k8s-monitor-lite-secrets
        alloy-singleton:
          enabled: false
        alloy-logs:
          enabled: false
        alloy-receiver:
          enabled: false
        alloy-profiles:
          enabled: false
        crds:
          deploy: true
