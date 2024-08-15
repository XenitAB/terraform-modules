apiVersion: v1
kind: Namespace
metadata:
 name: azureserviceoperator-system
 labels:
   name: azureserviceoperator-system
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: aso2
  namespace: azureserviceoperator-system
spec:
  interval: 1m0s
  url: "https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: azure-service-operator
  namespace: azureserviceoperator-system
spec:
  chart:
    spec:
      chart: azure-service-operator
      sourceRef:
        kind: HelmRepository
        name: aso2
      version: v2.7.0
  interval: 1m0s
  values:
    azureSyncPeriod: "${sync_period}"
    crdPattern: "${crd_pattern}"
    metrics:
      enable: ${enable_metrics}
    networkPolicies:
      enable: false

    
    
