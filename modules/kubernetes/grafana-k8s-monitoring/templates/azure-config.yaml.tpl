apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-k8s-monitor-secrets
  namespace: grafana-k8s-monitor
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: prometheus-grafana-cloud-user
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-password
          objectType: secret
        - |
          objectName: loki-grafana-cloud-user
          objectType: secret
        - |
          objectName: loki-grafana-cloud-password
          objectType: secret
        - |
          objectName: tempo-grafana-cloud-user
          objectType: secret
        - |
          objectName: tempo-grafana-cloud-password
          objectType: secret
  secretObjects:
    - secretName: prometheus-grafana-cloud
      type: Opaque
      data:
        - objectName: prometheus-grafana-cloud-user
          key: user
        - objectName: prometheus-grafana-cloud-password
          key: password
    - secretName: loki-grafana-cloud
      type: Opaque
      data:
        - objectName: loki-grafana-cloud-user
          key: user
        - objectName: loki-grafana-cloud-password
          key: password
    - secretName: tempo-grafana-cloud
      type: Opaque
      data:
        - objectName: tempo-grafana-cloud-user
          key: user
        - objectName: tempo-grafana-cloud-password
          key: password
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: grafana-k8s-monitor-secret-mount
  namespace: grafana-k8s-monitor
  annotations:
    azure.workload.identity/client-id: ${client_id}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-k8s-monitor-secret-mount
  namespace: grafana-k8s-monitor
  labels:
    azure.workload.identity/use: "true"
spec:
  selector:
    matchLabels:
      app: grafana-k8s-monitor-secret-mount
  template:
    metadata:
      labels:
        app: grafana-k8s-monitor-secret-mount
    spec:
      serviceAccountName: grafana-k8s-monitor-secret-mount
      containers:
        - name: busybox
          image: busybox:latest
          command: ["/bin/sh", "-c", "--"]
          args: ["while true; do sleep 30; done;"]
          tty: true
          volumeMounts:
            - name: secret-store
              mountPath: "/mnt/secrets-store"
              readOnly: true
          env:
            - name: grafana-k8s-monitor-operator-apikey
              valueFrom:
                secretKeyRef:
                  name: grafana-k8s-monitor-operator-apikey
                  key: api-key
            - name: grafana-k8s-monitor-operator-appkey
              valueFrom:
                secretKeyRef:
                  name: grafana-k8s-monitor-operator-appkey
                  key: app-key
      volumes:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: grafana-k8s-monitor-secrets
