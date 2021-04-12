replicaCount: 2

application:
  environment: ${environment}

affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        - key: app.kubernetes.io/name
          operator: In
          values:
          - ingress-healthz
        topologyKey: kubernetes.io/hostname

ingress:
  hosts:
    - host: ingress-healthz.${dns_zone}
      paths:
        - /cluster-health/healthz
  tls:
    - host: ingress-healthz.${dns_zone}
