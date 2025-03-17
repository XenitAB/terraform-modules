%{~ if default_certificate.enabled ~}
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${ingress_nginx_name}
  namespace: ingress-nginx
spec:
  secretName: ${ingress_nginx_name}
  revisionHistoryLimit: 3
  dnsNames:
    - '*.${default_certificate.dns_zone}'
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt

%{~ endif ~}
%{~ if nginx_healthz_ingress_enabled ~}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-healthz
  namespace: ingress-nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
    nginx.ingress.kubernetes.io/whitelist-source-range: >-
      ${nginx_healthz_ingress_whitelist_ips}
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - "health.${nginx_healthz_ingress_hostname}"
      secretName: healthz-ingress-secret
  rules:
  - host: "health.${nginx_healthz_ingress_hostname}"
    http:
      paths:
      - path: /healthz
        pathType: Prefix
        backend:
          service:
            name: ingress-nginx-controller-metrics
            port:
              number: 10254
%{~ endif ~}