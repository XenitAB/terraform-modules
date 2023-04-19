apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: datadog-secrets
  namespace: datadog
spec:
  provider: aws
  parameters:
    objects: |
      array:
        - |
          objectName: "application/datadog-secrets/datadog-api-key"
          objectType: "ssmparameter"
          objectAlias: "datadog-api-key"
        - |
          objectName: "application/datadog-secrets/datadog-app-key"
          objectType: "ssmparameter"
          objectAlias: "datadog-app-key"
  secretObjects:
    - secretName: datadog-operator-appkey
      type: Opaque
      data:
        - objectName: datadog-app-key
          key: app-key
    - secretName: datadog-operator-apikey
      type: Opaque
      data:
        - objectName: datadog-api-key
          key: api-key
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: datadog
  namespace: datadog
  annotations:
    ${role_arn}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: datadog-secret-mount
  namespace: datadog
spec:
  selector:
    matchLabels:
      app: datadog-secret-mount
  template:
    metadata:
      labels:
        app: datadog-secret-mount
    spec:
      serviceAccountName: datadog
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
            - name: datadog-operator-apikey
              valueFrom:
                secretKeyRef:
                  name: datadog-operator-apikey
                  key: api-key
            - name: datadog-operator-appkey
              valueFrom:
                secretKeyRef:
                  name: datadog-operator-appkey
                  key: app-key
      volumes:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: datadog-secrets
