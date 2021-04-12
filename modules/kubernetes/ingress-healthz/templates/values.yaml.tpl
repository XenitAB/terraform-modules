replicaCount: 2

application:
  environment: ${environment}

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - ingress-healthz
          topologyKey: kubernetes.io/hostname
        weight: 100
      - podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - ingress-healthz
          topologyKey: topology.kubernetes.io/zone
        weight: 100

ingress:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /healthz
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt
  hosts:
    - host: ingress-healthz.${dns_zone}
      paths:
        - /cluster-health/healthz
  tls:
    - hosts:
        - ingress-healthz.${dns_zone}
      secretName: ingress-healthz-cert
