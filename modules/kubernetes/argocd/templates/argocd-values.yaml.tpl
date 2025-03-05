crds:
  keep: false

redis-ha:
  enabled: true

controller:
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "5851df2a-5cc7-4030-bf5a-48dcc5f6cf42"
      azure.workload.identity/tenant-id: "a1b44af3-4c00-4531-ae80-f3f67fba126f"
  replicas: ${controller_min_replicas}
  volumes:
  - name: azure-identity-token
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: azure-identity-token
  - name: optigroup-azure-identity-token
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: optigroup-azure-identity-token
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-identity-token
    readOnly: true
  - mountPath: /var/run/secrets/optigroup
    name: optigroup-azure-identity-token
    readOnly: true

repoServer:
  autoscaling:
    enabled: true
    minReplicas: ${repo_server_min_replicas}

applicationSet:
  replicas: ${application_set_replicas}

global:
  domain: argocd.sand.unbox.xenit.io
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
      azure.workload.identity/client-id: "5851df2a-5cc7-4030-bf5a-48dcc5f6cf42"
      azure.workload.identity/tenant-id: "a1b44af3-4c00-4531-ae80-f3f67fba126f"
  volumes:
  - name: azure-identity-token
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: azure-identity-token
  - name: optigroup-azure-identity-token
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          audience: api://AzureADTokenExchange
          expirationSeconds: 3600
          path: optigroup-azure-identity-token
  volumeMounts:
  - mountPath: /var/run/secrets/tokens
    name: azure-identity-token
    readOnly: true
  - mountPath: /var/run/secrets/optigroup
    name: optigroup-azure-identity-token
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
          clientID: ${client_id}
          clientSecret: ${client_secret}
          redirectURI: http://127.0.0.1:5556/dex/callback
          tenant: ${tenant}
          groups:
            - ${aad_group_name}
  params:
    server.insecure: "true"
  rbac:
    create: true
    policy.csv: |
      g, ${aad_group_name}, role:admin