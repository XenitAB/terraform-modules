crds:
  keep: false

redis-ha:
  enabled: true

controller:
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "${client_id}"
      azure.workload.identity/tenant-id: "${tenant_id}"
  replicas: ${controller_min_replicas}
  volumes:
  - name: azure-federated-tokens
    projected:
      defaultMode: 420
      sources:
      %{ for tenant in azure_tenants ~}
      %{ for cluster in tenant.clusters ~}
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: ${tenant.tenant_name}-${cluster.environment}-federated-token-file
      %{ endfor }
      %{ endfor }
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-federated-tokens
    readOnly: true

repoServer:
  autoscaling:
    enabled: true
    minReplicas: ${repo_server_min_replicas}

applicationSet:
  replicas: ${application_set_replicas}

global:
  domain: ${global_domain}
  # Do we want to be able to run argo on system pool or spot instances?
  # tolerations: 

configs:
  params:
    server.insecure: true

server:
  autoscaling:
    enabled: true
    minReplicas: ${server_min_replicas}
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/issuer: "letsencrypt"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      nginx.ingress.kubernetes.io/limit-whitelist: "${ingress_whitelist_ip}"
    extraTls:
      - hosts:
        - ${global_domain}
        secretName: argocd-tls
  log:
    level: debug
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "${client_id}"
      azure.workload.identity/tenant-id: "${tenant_id}"
  volumes:
  - name: azure-federated-tokens
    projected:
      defaultMode: 420
      sources:
      %{ for tenant in azure_tenants ~}
      %{ for cluster in tenant.clusters ~}
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: ${tenant.tenant_name}-${cluster.environment}-federated-token-file
      %{ endfor }
      %{ endfor }
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-federated-tokens
    readOnly: true

configs:
  cm:
    admin.enabled: false
    dex.config: |
      connectors:
      - type: microsoft
        id: microsoft
        name: Microsoft
        config:
          # Credentials can be string literals or pulled from the environment.
          clientID: ${dex_client_id}
          clientSecret: ${dex_client_secret}
          redirectURI: http://127.0.0.1:5556/dex/callback
          tenant: ${dex_tenant_name}
          groups:
            - ${aad_group_name}
  params:
    server.insecure: "true"
  rbac:
    create: true
    policy.csv: |
      g, ${aad_group_name}, role:admin