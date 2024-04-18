apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: vector
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: vector
spec:
  azureIdentity: vector
  selector: vector
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: vector
spec:
  provider: "azure"
  parameters:
    usePodIdentity: "true"
    keyvaultName: "${azure_key_vault_name}"
    objects:  |
      array:
        - |
          objectName: "eventhub-connectionstring"
          objectType: secret
    tenantId: "${tenant_id}"
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
    {{- include "vector.labels" . | nindent 4 }}
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