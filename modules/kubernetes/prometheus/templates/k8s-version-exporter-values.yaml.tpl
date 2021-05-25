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

service:
  type: ClusterIP

serviceAccount:
  create: true

serverBlock: |-
  server {
    listen 0.0.0.0:8080;

    location /metrics {
      alias /tmp/metrics/metrics.txt;
    }
  }

extraVolumes:
  - emptyDir: {}
    name: temp
  - emptyDir: {}
    name: metrics

extraVolumeMounts:
  - mountPath: /opt/bitnami/nginx/tmp/
    name: temp
  - mountPath: /tmp/metrics/
    name: metrics

sidecars:
  - name: metrics-collector
    image: bitnami/kubectl:1.20.7
    imagePullPolicy: IfNotPresent
    command: ["/bin/sh"]
    args:
      - -c
      - while true; do VERSION=$(kubectl version -o json); echo "k8sversion_build_info{major=$(echo $VERSION | jq .serverVersion.major),minor=$(echo $VERSION | jq .serverVersion.minor),version=$(echo $VERSION | jq .serverVersion.gitVersion),commit=$(echo $VERSION | jq .serverVersion.gitCommit)} 1" > /tmp/metrics/metrics.txt; sleep 60; done;
    volumeMounts:
      - mountPath: /tmp/metrics/
        name: metrics
