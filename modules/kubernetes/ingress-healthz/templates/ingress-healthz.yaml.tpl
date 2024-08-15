apiVersion: v1
kind: Namespace
metadata:
 name: ingress-healthz
 labels:
   name: ingress-healthz
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: ingress-healthz
  namespace: ingress-healthz
spec:
  interval: 1m0s
  url: "https://charts.bitnami.com/bitnami"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: ingress-healthz
  namespace: ingress-healthz
spec:
  chart:
    spec:
      chart: nginx
      sourceRef:
        kind: HelmRepository
        name: ingress-healthz
      version: 15.5.2
  values:
    replicaCount: 2
    priorityClassName: platform-low
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
      sysctls: "null"
    service:
      type: ClusterIP
    ingress:
      enabled: true
      ingressClassName: ${ingress_class_name}
      %{ if location_short == "" }
      hostname: ingress-healthz.${dns_zone}
      %{ else }
      hostname: ingress-healthz-${location_short}.${dns_zone}
      %{ endif }
      annotations:
        %{ if linkerd_enabled }
        nginx.ingress.kubernetes.io/configuration-snippet: |
          proxy_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
          grpc_set_header l5d-dst-override $service_name.$namespace.svc.cluster.local:$service_port;
        %{ endif }
        cert-manager.io/cluster-issuer: letsencrypt
      tls: true
      extraHosts:
          - hosts:
        %{ if location_short == "" }
            - ingress-healthz.${dns_zone}
        %{ else }
            - ingress-healthz-${location_short}.${dns_zone}
        %{ endif }
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
      - name: temp
        emptyDir: {}
    extraVolumeMounts:
      - name: temp
        mountPath: /opt/bitnami/nginx/tmp/
  interval: 1m0s