apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: datadog
  namespace: datadog
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: datadog
  namespace: datadog
spec:
  azureIdentity: datadog
  selector: datadog
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: datadog-secrets
  namespace: datadog
spec:
  provider: azure
  parameters:
    usePodIdentity: "true"
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: datadog-api-key
          objectType: secret
        - |
          objectName: datadog-app-key
          objectType: secret
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
apiVersion: apps/v1
kind: Deployment
metadata:
  name: datadog-secret-mount
  namespace: datadog
  labels:
    aadpodidbinding: datadog
spec:
  selector:
    matchLabels:
      app: datadog-secret-mount
  template:
    metadata:
      labels:
        app: datadog-secret-mount
        aadpodidbinding: datadog
    spec:
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
