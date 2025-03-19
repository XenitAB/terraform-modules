apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: logs-cert-manager
  labels:
    xkf.xenit.io/kind: platform
rules:
  - verbs:
      - list
      - view
      - logs
    apiGroups:
      - ''
    resources:
      - pods
---
%{ for namespace in namespaces ~}
%{ for name, id in aad_groups ~}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${namespace}-logs-cert-manager
  namespace: cert-manager
  labels:
    aad-group-name: ${name}
    xkf.xenit.io/kind: platform
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: ${id}
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: logs-cert-manager
---
%{ endfor }
%{ endfor }
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