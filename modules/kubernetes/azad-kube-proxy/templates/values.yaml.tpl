application:
  port: 8080
  metricsPort: 8081
  scheme: HTTP

podEnv:
  - name: CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: CLIENT_ID
  - name: CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: CLIENT_SECRET
  - name: TENANT_ID
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: TENANT_ID
  - name: TLS_ENABLED
    value: "false"
  - name: GROUP_IDENTIFIER
    value: "OBJECTID"
  - name: AZURE_AD_GROUP_PREFIX
    value: "${azure_ad_group_prefix}"
%{ if dashboard == "k8dash" }
  - name: DASHBOARD
    value: "K8DASH"
  - name: K8DASH_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: K8DASH_CLIENT_ID
  - name: K8DASH_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: K8DASH_CLIENT_SECRET
  - name: K8DASH_SCOPE
    valueFrom:
      secretKeyRef:
        name: azad-kube-proxy
        key: K8DASH_SCOPE
%{ endif }

secret:
  create: false
  name: azad-kube-proxy

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5

ingress:
  enabled: true
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt"
    nginx.ingress.kubernetes.io/whitelist-source-range: "${allowed_ips_csv}"
  hosts:
  - host: "${fqdn}"
    paths:
    - path: /
      backend:
        serviceName: azad-kube-proxy
        servicePort: http
  tls:
  - secretName: azad-kube-proxy-cert
    hosts:
    - "${fqdn}"

podAnnotations:
  secret.reloader.stakater.com/reload: "azad-kube-proxy"
