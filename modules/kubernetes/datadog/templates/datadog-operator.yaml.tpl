
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
    keyvaultName: "kv-sand-we-core-7844"
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
