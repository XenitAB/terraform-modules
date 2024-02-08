apiVersion: v1
kind: Namespace
metadata:
 name: cert-manager
 labels:
   name              = "cert-manager"
   xkf.xenit.io/kind = "platform"
---
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
      version: v1.7.1
  interval: 1m0s
  values:
    global:
      priorityClassName: "platform-medium"

    podLabels:
      aadpodidbinding: cert-manager
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
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: cert-manager
spec:
  type: 0
  resourceID: ${azure_config.resource_id}
  clientID: ${azure_config.client_id }
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: cert-manager
spec:
  azureIdentity: cert-manager
  selector: cert-manager
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: ${notification_email}
    server: ${acme_server}
    privateKeySecretRef:
      name: letsencrypt-cluster-issuer-account-key
    solvers:
    - selector:
        dnsZones: 
          - ${azure_config.hosted_zone_names}
      dns01:
          azureDNS:
            environment: AzurePublicCloud
            subscriptionID: ${azure_config.subscription_id}
            resourceGroupName: ${azure_config.resource_group_name}
            hostedZoneName: ${azure_config.hosted_zone_names}

