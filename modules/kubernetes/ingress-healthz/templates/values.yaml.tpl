replicaCount: 2

resources:
  requests:
     cpu: 50m
     memory: 64Mi
  limits:
    memory: 128Mi

service:
  type: ClusterIP

ingress:
  enabled: true
  hostname: ingress-healthz.${dns_zone}
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
  extraTls:
    - hosts:
        - ingress-healthz.${dns_zone}
      secretName: ingress-healthz-cert

pdb:
  create: true
  minAvailable: 1

serverBlock: |-
  server {
    listen 0.0.0.0:8080;
    root /app;

    location / {
      ssi on;
      ssi_types *;
      add_header Content-Type application/json;
      return 200 '{"status": "pass", "environment": "${environment}", "date": "<!--# config timefmt="%c" --><!--#echo var="date_local"-->"}';
    }
  }

extraVolumes:
  - emptyDir: {}
    name: temp

extraVolumeMounts:
  - mountPath: /opt/bitnami/nginx/tmp/
    name: temp

