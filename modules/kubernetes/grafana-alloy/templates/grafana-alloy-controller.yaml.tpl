apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: grafana-alloy
  namespace: grafana-alloy
spec:
  interval: 1m0s
  url: "https://grafana.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: grafana-alloy
  namespace: grafana-alloy
spec:
  chart:
    spec:
      chart: alloy
      sourceRef:
        kind: HelmRepository
        name: grafana-alloy
      version: 0.9.1
  values:
    serviceAccount:
      create: true
      annotations:
        azure.workload.identity/client-id: ${client_id}
    alloy:
      extraPorts:
        - name: otpl-http-trace
          port: 4318
          targetPort: 4318
          protocol: TCP
      mounts:
        extra:
          - mountPath: /tmp/alloy
            name: temp-storage
          - name: secret-store
            mountPath: "/mnt/secrets-store"
            readOnly: true
      securityContext:
        runAsUser: 473
        runAsGroup: 473
      configMap:
        create: false
        name: grafana-alloy-config
        key: config
    controller:
      podLabels:
        azure.workload.identity/use: "true"
      type: 'deployment'
      volumes:
        extra:
        - name: temp-storage
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: grafana-alloy-secrets
  interval: 1m0s
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-alloy-config
  namespace: grafana-alloy
data:
  config: |-
    discovery.kubernetes "pods" {
      role = "pod"
    }

    prometheus.scrape "flux_system_pods" {
      job_name = "integrations/flux_system_pods"
      targets = discovery.kubernetes.pods.targets
      scrape_interval = "60s"
      forward_to     = [prometheus.relabel.metrics_service.receiver]
      clustering {
        enabled = true
      }
    }

    prometheus.relabel "metrics_service" {
      max_cache_size = 100000
      rule {
        source_labels = ["cluster"]
        regex = ""
        replacement = ${grafana_alloy_config.cluster_name}
        target_label = "cluster"
      }
      rule {
          source_labels = ["namespace"]
          regex = "^$|flux-system"
          action = "keep"
      }
      forward_to = [prometheus.remote_write.metrics_service.receiver]
    }

    remote.kubernetes.secret "metrics_service" {
      name = "prometheus-grafana-cloud"
      namespace = "grafana-alloy"
    } 

    prometheus.remote_write "metrics_service" {
      endpoint {
        url = nonsensitive(remote.kubernetes.secret.metrics_service.data["host"]) + "/api/prom/push"
        headers = { "X-Scope-OrgID" = nonsensitive(remote.kubernetes.secret.metrics_service.data["tenantId"]) }

        basic_auth {
          username = nonsensitive(remote.kubernetes.secret.metrics_service.data["username"])
          password = remote.kubernetes.secret.metrics_service.data["password"]
        }

        send_native_histograms = false

        queue_config {
          capacity = 10000
          min_shards = 1
          max_shards = 50
          max_samples_per_send = 2000
          batch_send_deadline = "5s"
          min_backoff = "30ms"
          max_backoff = "5s"
          retry_on_http_429 = true
          sample_age_limit = "0s"
        }
      }

      wal {
        truncate_frequency = "2h"
        min_keepalive_time = "5m"
        max_keepalive_time = "8h"
      }

      external_labels = {
      }
    }
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-alloy-secrets
  namespace: grafana-alloy
spec:
  provider: azure
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_config.azure_key_vault_name}
    tenantId: ${tenant_id}
    objects: |
      array:
        - |
          objectName: prometheus-grafana-cloud-host
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-user
          objectType: secret
        - |
          objectName: prometheus-grafana-cloud-password
          objectType: secret
  secretObjects:
    - secretName: prometheus-grafana-cloud
      type: Opaque
      data:
        - objectName: prometheus-grafana-cloud-host
          key: host
        - objectName: prometheus-grafana-cloud-user
          key: username
        - objectName: prometheus-grafana-cloud-password
          key: password
