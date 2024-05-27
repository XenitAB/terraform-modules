apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: vector
  namespace: controle-plane-logs
spec:
  provider: "azure"
  parameters:
    clientID: ${client_id}
    keyvaultName: ${azure_key_vault_name}
    tenantId: ${tenant_id}
    objects:  |
      array:
        - |
          objectName: "eventhub-connectionstring"
          objectType: secret
  secretObjects:
    - secretName: "msg-queue"
      type: Opaque
      data:
        - objectName: "eventhub-connectionstring"
          key: connectionstring
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: "vector"
  namespace: controle-plane-logs
  labels:
    app.kubernetes.io/instance: vector
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: vector
    app.kubernetes.io/version: 0.37.1-distroless-libc
    helm.sh/chart: vector-0.32.1
    meta.helm.sh/release-name: vector
    meta.helm.sh/release-namespace: controle-plane-logs
data:
  hostname: ${eventhub_hostname }
  topic: ${eventhub_name }
  vector.toml: |
    ## Kafka source
    [sources.in_azure_events]
      type = "kafka"
      bootstrap_servers = "$${HOST:?err}"
      topics = ["$${TOPIC:?err}"]  # event hub name
      group_id = '$$Default'
      librdkafka_options."security.protocol" = "sasl_ssl"

    [sources.in_azure_events.sasl]
      enabled = true
      mechanism = "PLAIN"
      username = "$$ConnectionString"
      password = "$${PASSWORD:?err}"

    [transforms.azure_events_parse]
      type = "remap"
      inputs = ["in_azure_events"]
      source = '''
      . = parse_json!(string!(.message))
      . = unnest!(.records)
      '''

    [transforms.post_unset]
      type = "remap"
      inputs = ["azure_events_parse"]
      source = '''
      . = {
        "category": .records.category,
        "log": .records.properties.log,
        "time": .records.time
      }
      '''

    [sinks.console]
      type = "console"
      inputs = [ "post_unset" ]
      target = "stdout"
      
    [sinks.console.encoding]
      codec = "json"