
apiVersion: v1
kind: Namespace
metadata:
 name: datadog
 labels:
   name              = "datadog"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: datadog
  namespace: datadog
spec:
  interval: 1m0s
  url: "https://helm.datadoghq.com"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: datadog-operator
  namespace: datadog
spec:
  chart:
    spec:
      chart: datadog-operator
      sourceRef:
        kind: HelmRepository
        name: datadog
      version: 0.8.0
  values:
    apiKeyExistingSecret: datadog-api-key
    appKeyExistingSecret: datadog-app-key
    installCRDs: true
    datadogMonitor:
      enabled: true
    resources:
      requests:
        cpu: 15m
        memory: 50Mi
  interval: 1m0s
---
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
    - secretName: datadog-app-key
      type: Opaque
      data:
        - objectName: datadog-app-key
          key: app-key
    - secretName: datadog-api-key
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
spec:
  selector:
    matchLabels:
      app: datadog-secret-mount
  template:
    metadata:
      labels:
        app: datadog-secret-mount
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
            - name: DATADOG-API-KEY
              valueFrom:
                secretKeyRef:
                  name: datadog-api-key
                  key: api-key
            - name: DATADOG-APP-KEY
              valueFrom:
                secretKeyRef:
                  name: datadog-app-key
                  key: app-key
      volumes:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: datadog-secrets
