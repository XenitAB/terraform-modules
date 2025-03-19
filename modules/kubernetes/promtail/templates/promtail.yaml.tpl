apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: promtail
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: promtail
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: 6.6.2
    chart: promtail
    helm:
      valuesObject:
        config:
          clients:
            - url: "${loki_address}"
              tls_config:
                cert_file: /mnt/tls/tls.crt
                key_file: /mnt/tls/tls.key
          snippets:
            pipelineStages:
              - cri: {}
              - static_labels:
                  region: "${region}"
                  environment: "${environment}"
                  cluster: "${cluster_name}"

              # Drop 2xx and 3xx from ingress-nginx since it it generates a lot of log messages. Example:
              # xxx.xxx.xxx.xxx - - [04/May/2022:13:12:50 +0000] "POST /api/v1/receive HTTP/2.0" 200 0 "-" "Prometheus/2.35.0"
              # 35234 0.004 [monitor-router-receiver-remote-write] [] 10.244.34.149:19291 0 0.004 200 0156a072a34b23dc09bcfcfe87991c7b
              - match:
                  selector: '{namespace="ingress-nginx"}'
                  stages:
                  - regex:
                      expression: '^(?P<_>[\w\.]+) - (?P<_>[^ ]*) \[(?P<_>.*)\] "(?P<_>[^ ]*) (?P<_>[^ ]*) (?P<_>[^ ]*)" (?P<nginx_status>[\d]+).*'
              - drop:
                  source: nginx_status
                  expression: "[2-3][0-9][0-9]"
                  drop_counter_reason: nginx_ok
            extraRelabelConfigs:
              %{~ for namespace in excluded_namespaces ~}
              - action: drop
                regex: ${namespace}
                source_labels:
                  - __meta_kubernetes_namespace
              %{~ endfor ~}
        priorityClassName: "platform-high"
        # Tolerate everything
        tolerations:
          - operator: Exists
            effect: NoSchedule
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 50m
            memory: 100Mi
        podLabels:
          azure.workload.identity/use: "true"
        extraVolumes:
          - name: secrets-store
            csi:
              driver: secrets-store.csi.k8s.io
              readOnly: true
              volumeAttributes:
                secretProviderClass: promtail
          - name: tls
            secret:
              secretName: "${k8s_secret_name}"
        extraVolumeMounts:
          - name: secrets-store
            mountPath: /mnt/secrets-store
          - name: tls
            mountPath: "/mnt/tls"
            readOnly: true
        serviceAccount:
          create: true
          name: promtail
          annotations:
            azure.workload.identity/client-id: ${client_id}
    sources:
    - repoURL: ${repo_url}
      targetRevision: HEAD
      path: platform/${tenant_name}/${cluster_id}/k8s-manifests/promtail