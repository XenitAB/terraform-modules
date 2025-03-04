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
      #azure.workload.identity/tenant-id": "$TENANT_ID"
  replicas: ${controller_min_replicas}

server:
  autoscaling:
    enabled: true
    minReplicas: ${server_min_replicas}
  podLabels:
    azure.workload.identity/use: "true" 
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: "5851df2a-5cc7-4030-bf5a-48dcc5f6cf42"
      #azure.workload.identity/tenant-id": "$TENANT_ID"

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

configs:
  cm:
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