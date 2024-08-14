apiVersion: v1
kind: Namespace
metadata:
 name: grafana-alloy
 labels:
   name: "grafana-alloy"
   xkf.xenit.io/kind: "platform"
---
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
      version: 0.5.1
  serviceAccountName: grafana-alloy-secret-mount
  values:
    alloy:
      extraEnv:
        - name: GRAFANA_CLOUD_API_KEY
          valueFrom:
            secretKeyRef:
              name: "${azure_config.keyvault_secret_name}"
              key: GRAFANA_CLOUD_API_KEY
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
      type: 'deployment'
      volumes:
        extra:
        - name: secret-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: grafana-alloy-secret
  interval: 1m0s
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-alloy-config
  namespace: grafana-alloy
data:
  config: |-
    logging {
      level = "info"
      format = "logfmt"
    }

    otelcol.receiver.otlp "otlp_receiver" {
      grpc {
        endpoint = "0.0.0.0:4317"
      }
      http {
        endpoint = "0.0.0.0:4318"
      }

      output {
        traces = [otelcol.processor.batch.grafanacloud.input]
      }
    }

    otelcol.processor.batch "grafanacloud" {
      output {
        traces = [otelcol.exporter.otlp.grafanacloud.input]
      }
    }

    otelcol.exporter.otlp "grafanacloud" {
      client {
        endpoint = $(grafana_otelcol_exporter_endpoint)
        auth = otelcol.auth.basic.grafanacloud.handler
      }
    }

    otelcol.auth.basic "grafanacloud" {
      username = $(grafana_otelcol_auth_basic_username)
    }
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: grafana-alloy-secrets
  namespace: grafana-alloy
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_config.azure_key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: "${azure_config.keyvault_secret_name}"
          objectType: secret
  secretObjects:
    - secretName: "${azure_config.keyvault_secret_name}"
      type: kubernetes.io/tls
      data:
        - objectName: "${azure_config.keyvault_secret_name}"
          key: GRAFANA_CLOUD_API_KEY

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: grafana-alloy-secret-mount
  namespace: grafana-alloy
  annotations:
    azure.workload.identity/client-id: ${client_id}
