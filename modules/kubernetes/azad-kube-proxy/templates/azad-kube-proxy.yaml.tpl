apiVersion: v1
kind: Namespace
metadata:
 name: azad-kube-proxy
 labels:
   name: azad-kube-proxy
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
spec:
  interval: 1m0s
  url: "https://xenitab.github.io/azad-kube-proxy/"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: azad-kube-proxy
  namespace: azad-kube-proxy
spec:
  chart:
    spec:
      chart: azad-kube-proxy
      sourceRef:
        kind: HelmRepository
        name: azad-kube-proxy
      version: v0.0.47
  interval: 1m0s
  values:
    application:
      port: 8080
      metricsPort: 8081
      scheme: HTTP

    podEnv:
      - name: CLIENT_ID
        valueFrom:
          secretKeyRef:
            name: azad-kube-proxy-${environment}-${location_short}-${name}
            key: CLIENT_ID
      - name: CLIENT_SECRET
        valueFrom:
          secretKeyRef:
            name: azad-kube-proxy-${environment}-${location_short}-${name}
            key: CLIENT_SECRET
      - name: TENANT_ID
        valueFrom:
          secretKeyRef:
            name: azad-kube-proxy-${environment}-${location_short}-${name}
            key: TENANT_ID
      - name: TLS_ENABLED
        value: "false"
      - name: GROUP_IDENTIFIER
        value: "OBJECTID"
      - name: AZURE_AD_GROUP_PREFIX
        value: ${azure_ad_group_prefix}

    secret:
      create: false
      name: azad-kube-proxy

    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 5

    ingress:
      enabled: true
    %{ if private_ingress_enabled == true && use_private_ingress == false }
      ingressClassName: "nginx"
    %{ endif }
    %{ if private_ingress_enabled == true && use_private_ingress == true }
      ingressClassName: "nginx-private"
    %{ endif }
      annotations:
        cert-manager.io/cluster-issuer: "letsencrypt"
        nginx.ingress.kubernetes.io/whitelist-source-range: ${allowed_ips_csv}
      hosts:
      - host: ${fqdn}
        paths:
        - path: /
          backend:
            serviceName: azad-kube-proxy
            servicePort: http
      tls:
      - secretName: azad-kube-proxy-cert
        hosts:
        - ${fqdn}

    podAnnotations:
      secret.reloader.stakater.com/reload: "azad-kube-proxy"

    resources:
      limits:
        memory: 70Mi
      requests:
        cpu: 10m
        memory: 32Mi