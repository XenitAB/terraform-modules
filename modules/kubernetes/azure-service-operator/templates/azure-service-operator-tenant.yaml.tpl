apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: azure-service-operator
  namespace: ${tenant_namespace}
spec:
  chart:
    spec:
      chart: azure-service-operator
      sourceRef:
        kind: HelmRepository
        name: aso2
        namespace: azureserviceoperator-system
      version: v2.7.0
  interval: 1m0s
  serviceAccountName: ${tenant_namespace}
  values:
    multitenant:
      enable: true
    azureOperatorMode: watchers
    useWorkloadIdentityAuth: true
    azureTenantID: ${tenant_id}
    azureSubscriptionID: ${subscription_id}
    azureClientID: "${client_id}"
    azureTargetNamespaces:
      - ${tenant_namespace}
    azureSyncPeriod: "${sync_period}"
    crdPattern: "${crd_pattern}"
    metrics:
      enable: ${enable_metrics}