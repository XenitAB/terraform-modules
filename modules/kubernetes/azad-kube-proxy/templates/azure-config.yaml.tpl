apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          objectType: secret
  secretObjects:
    - secretName: azad-kube-proxy-${environment}-${location_short}-${name}
      type: Opaque
      data:
        - objectName: azad-kube-proxy-${environment}-${location_short}-${name}
          key: CLIENT_SECRET
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
  annotations:
    azure.workload.identity/client-id: ${client_id}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azad-kube-proxy-secret-mount
  namespace: azad-kube-proxy
  labels:
    azure.workload.identity/use: "true"
spec:
  selector:
    matchLabels:
      app: azad-kube-proxy-secret-mount
  template:
    metadata:
      labels:
        app: azad-kube-proxy-secret-mount
    spec:
      serviceAccountName: azad-kube-proxy
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
            - name: CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: azad-kube-proxy-${environment}-${location_short}-${name}
                  key: CLIENT_SECRET
      volumes:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: azad-kube-proxy
