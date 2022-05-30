replicaCount: 2

priorityClassName: "platform-low"

resources:
  requests:
     cpu: 50m
     memory: 64Mi
  limits:
    memory: 128Mi

containerSecurityContext:
  enabled: true
  runAsUser: 1001
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - NET_RAW
  # Work around until PR gets merged
  # https://github.com/bitnami/charts/pull/6101
  sysctls: null

service:
  type: ClusterIP

ingress:
  enabled: true
  hostname: ingress-healthz-${location_short}.${dns_zone}
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    %{ if linkerd_enabled }
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
      grpc_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
    %{ endif }
  extraTls:
    - hosts:
        - ingress-healthz-${location_short}.${dns_zone}
      secretName: ingress-healthz-cert

%{ if linkerd_enabled }
podAnnotations:
  linkerd.io/inject: enabled
%{ endif }

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

