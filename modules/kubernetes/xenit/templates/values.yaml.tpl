replicaCount: 2

priorityClassName: "platform-low"

podAnnotations:
  secret.reloader.stakater.com/reload: "xenit-proxy-certificate"

%{ if cloud_provider == "azure" }
podLabels:
  aadpodidbinding: "xenit-proxy"
  app: "xenit-proxy"
%{ endif }
%{ if cloud_provider == "aws" }
serviceAccount:
  create: true
  name: "xenit-proxy"
  annotations:
    "eks.amazonaws.com/role-arn": "${aws_config.role_arn}"
%{ endif }

resources:
  requests:
     cpu: 50m
     memory: 64Mi
  limits:
    memory: 128Mi

service:
  type: ClusterIP

pdb:
  create: true
  minAvailable: 1

serverBlock: |-
  server_names_hash_bucket_size 128;

  server {
      listen 8080;
      server_name thanos-receiver.xenit-system.svc.cluster.local;
      location / {
          proxy_pass https://${thanos_receiver_fqdn};
          proxy_set_header Host ${thanos_receiver_fqdn};
          proxy_ssl_name ${thanos_receiver_fqdn};
          proxy_ssl_server_name on;
          proxy_ssl_certificate "/mnt/tls/tls.crt";
          proxy_ssl_certificate_key "/mnt/tls/tls.key";
          proxy_redirect off;
      }
  }
  # server {
  #     listen 8080;
  #     server_name loki-api.xenit-system.svc.cluster.local;
  #     location / {
  #         proxy_pass https://${loki_api_fqdn};
  #         proxy_set_header Host ${loki_api_fqdn};
  #         proxy_ssl_name ${loki_api_fqdn};
  #         proxy_ssl_server_name on;
  #         proxy_ssl_certificate "/mnt/tls/tls.crt";
  #         proxy_ssl_certificate_key "/mnt/tls/tls.key";
  #         proxy_redirect off;
  #     }
  # }

extraVolumes:
  - emptyDir: {}
    name: temp
  - name: "secrets-store"
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: xenit-proxy
  - name: tls
    secret:
      secretName: xenit-proxy-certificate

extraVolumeMounts:
  - name: temp
    mountPath: /opt/bitnami/nginx/tmp/
  - name: "secrets-store"
    mountPath: "/mnt/secrets-store"
    readOnly: true
  - name: tls
    mountPath: "/mnt/tls"
    readOnly: true
