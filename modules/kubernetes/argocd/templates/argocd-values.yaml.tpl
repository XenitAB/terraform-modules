crds:
  keep: false

redis-ha:
  enabled: true

controller:
  replicas: ${controller_min_replicas}

server:
  autoscaling:
    enabled: true
    minReplicas: ${server_min_replicas}

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
        # Based on the ingress controller used secret might be optional
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
            - az-sub-xks-all-owner
  params:
    - "server.insecure": "true"