apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: xks
spec:
  version: v2.41.0
  scrapeInterval: "1m"
  podMetadata:
    labels:
      aadpodidbinding: prometheus
  containers:
    - name: prometheus
      args:
        - --config.file=/etc/prometheus/config_out/prometheus.env.yaml
        - --storage.agent.path=/prometheus
        - --enable-feature=agent
        - --web.enable-lifecycle
        - --web.console.templates=/etc/prometheus/consoles
        - --web.console.libraries=/etc/prometheus/console_libraries
        - --web.route-prefix=/
        - --web.config.file=/etc/prometheus/web_config/web-config.yaml
  enableFeatures:
    - agent
  externalLabels:
    cluster_name: ${cluster_name}
    environment: ${environment}
    region: ${region}
    %{ if tenant_id }
    tenant_id: ${tenant_id}
    %{ endif }
  replicas: 2
  priorityClassName: "platform-medium"
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchExpressions:
      - key: xkf.xenit.io/monitoring
        operator: In
        values: [platform]
  serviceMonitorNamespaceSelector:
    matchExpressions:
      - key: xkf.xenit.io/kind
        operator: In
        values: [platform]
  probeSelector:
    matchExpressions:
      - key: xkf.xenit.io/monitoring
        operator: In
        values: [platform]
  probeNamespaceSelector:
    matchExpressions:
      - key: xkf.xenit.io/kind
        operator: In
        values: [platform]
  podMonitorSelector:
    matchExpressions:
      - key: xkf.xenit.io/monitoring
        operator: In
        values: [platform]
  podMonitorNamespaceSelector:
    matchExpressions:
      - key: xkf.xenit.io/kind
        operator: In
        values: [platform]
  remoteWrite:
    - name: thanos
      url: ""
      headers: {}
      authenticated: true

      # Setting according to others observation
      # https://github.com/prometheus/prometheus/pull/9634
      # Check docs for more information about settings
      # https://prometheus.io/docs/practices/remote_write/
      queueConfig:
        capacity: 2500
        maxBackoff: 5s
        maxSamplesPerSend: 500
        maxShards: 50
      tlsConfig:
        certFile: /mnt/tls/tls.crt
        keyFile: /mnt/tls/tls.key

  resources:
    requests:
      memory: "2Gi"
      cpu: "20m"
    limits:
      memory: "6Gi"
  storage:
    volumeClaimTemplate:
      spec:
        storageClassName: default
        resources:
          requests:
            storage: 5Gi
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - podAffinityTerm:
            labelSelector:
              matchExpressions:
                - key: prometheus
                  operator: In
                  values:
                    - xks
            topologyKey: kubernetes.io/hostname
          weight: 100
        - podAffinityTerm:
            labelSelector:
              matchExpressions:
                - key: prometheus
                  operator: In
                  values:
                    - xks
            topologyKey: topology.kubernetes.io/zone
          weight: 100
  securityContext:
    fsGroup: 2000
    runAsNonRoot: true
    runAsUser: 1000
  volumeMounts:
    - mountPath: /mnt/secrets-store
      name: secrets-store
    - name: tls
      mountPath: "/mnt/tls"
      readOnly: true
  volumes:
    - name: secrets-store
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: prometheus
    - name: tls
      secret:
        secretName: xenit-proxy-certificate
