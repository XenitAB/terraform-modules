apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: aad-pod-identity
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: aad-pod-identity
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
    targetRevision: 4.1.16
    chart: aad-pod-identity
    helm:
      valuesObject:
        forceNameSpaced: true
        mic:
          prometheusPort: 8888
          priorityClassName: "platform-medium"
        nmi:
          allowNetworkPluginKubenet: true
          prometheusPort: 9090
          priorityClassName: "platform-high"
          tolerations:
          - operator: "Exists"
        azureIdentities:
%{ for namespace in namespaces ~}
          "${namespace.name}":
            namespace: "${namespace.name}"
            type: "0"
            resourceID: "${aad_pod_identity[namespace.name].id}"
            clientID: "${aad_pod_identity[namespace.name].client_id}"
            binding:
              name: "${namespace.name}"
              selector: "${namespace.name}"
%{ endfor }