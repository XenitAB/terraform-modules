apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  interval: 1m0s
  url: "https://charts.jetstack.io"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  chart:
    spec:
      chart: cert-manager
      sourceRef:
        kind: HelmRepository
        name: cert-manager
      version: v1.15.3
  interval: 1m0s
  values:
    global:
      priorityClassName: "platform-medium"
    %{~ if gateway_api_enabled ~}
    config:
      apiVersion: controller.config.cert-manager.io/v1alpha1
      kind: ControllerConfiguration
      enableGatewayAPI: true
    %{~ endif ~}
    podLabels:
      azure.workload.identity/use: "true"
    serviceAccount:
      annotations:
        azure.workload.identity/client-id: ${client_id}
    tolerations:
      - key: "kubernetes.azure.com/scalesetpriority"
        operator: "Equal"
        value: "spot"
        effect: "NoSchedule"
    webhook:
      resources:
        requests:
          cpu: 30m
          memory: 100Mi
    requests:
      cpu: 15m
      memory: 150Mi
    cainjector:
      resources:
        requests:
          cpu: 25m
          memory: 250Mi
    dns01RecursiveNameserversOnly: true
    dns01RecursiveNameservers: "8.8.8.8:53,1.1.1.1:53"
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
  namespace: cert-manager
spec:
  acme:
    email: ${notification_email}
    server: ${acme_server}
    privateKeySecretRef:
      name: letsencrypt-cluster-issuer-account-key
    solvers:
%{ for zone, id in dns_zones ~}
      - dns01:
          azureDNS:
            environment: AzurePublicCloud
            subscriptionID: ${subscription_id}
            resourceGroupName: ${resource_group_name}
            hostedZoneName: ${zone}
            managedIdentity:
              clientID: ${client_id}
        selector:
          dnsZones: 
            - ${zone}
%{ endfor }
       %{~ if gateway_api_enabled ~}
      - http01:
          gatewayHTTPRoute:
            parentRefs: 
            - name: ${gateway_solver_name}
              namespace: ${gateway_solver_namespace}
              kind: Gateway
      %{~ endif ~}