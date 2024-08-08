apiVersion: v1
kind: Namespace
metadata:
 name: grafana-alloy
 labels:
   name: "grafana-alloy"
   xkf.xenit.io/kind: "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: grafana-alloy
  namespace: grafana-alloy
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: grafana-alloy
  namespace: grafana-alloy
spec:
  chart:
    spec:
      chart: alloy
      sourceRef:
        kind: HelmRepository
        name: grafana
      version: 0.5.1
  values:
    alloy:
      extraEnv:
        - name: GRAFANA_CLOUD_API_KEY
          valueFrom:
            secretKeyRef:
              name: grafana-cloud-api-key
              key: GRAFANA_CLOUD_API_KEY
      extraPorts:
        - name: otpl-http-trace
          port: 4318
          targetPort: 4318
          protocol: TCP
      mounts:
        extra:
          - mountPath: /tmp/alloy
            name: temp-storage
          - name: secret-store
            mountPath: "/mnt/secrets-store"
            readOnly: true
      securityContext:
        runAsUser: 473
        runAsGroup: 473
      configMap:
        content: |-
          %{~ if alloy-configmap-config != "" ~}
            ${ alloy-configmap-config }
          %{~ endif ~}
    controller:
      type: 'deployment'
      volumes:
        extra:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: grafana-alloy-secret
  interval: 1m0s
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-alloy-secrets
  namespace: grafana-alloy
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: grafana-cloud-api-key
          objectType: secret
  secretObjects:
    - secretName: grafana-cloud-api-key
      type: Opaque
      data:
        - objectName: grafana-cloud-api-key
          key: GRAFANA_CLOUD_API_KEY
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: grafana-alloy-secret-mount
  namespace: grafana-alloy
  annotations:
    azure.workload.identity/client-id: ${client_id}
