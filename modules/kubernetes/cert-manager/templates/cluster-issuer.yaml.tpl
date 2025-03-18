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