%{~ if logs_enabled ~}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: logs-ingress-nginx
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
%{ for group in aad_groups ~}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${group.namespace}-logs-ingress-nginx
  namespace: ingress-nginx
  labels:
    aad-group-name: ${group.name}
    xkf.xenit.io/kind: platform
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: ${group.id}
    namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: logs-ingress-nginx
---
%{ endfor }
%{ endif }
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