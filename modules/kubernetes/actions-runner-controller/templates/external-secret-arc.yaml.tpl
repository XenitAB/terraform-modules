# Created here so the ESO resources below have a namespace before the runner-set
# Application (which also targets it) has synced. ArgoCD applies Namespace first.
apiVersion: v1
kind: Namespace
metadata:
  name: ${runners_namespace}
  labels:
    xkf.xenit.io/kind: platform
---
# GitHub App credentials for the ARC listener.
#
# Only the private key is a secret. The app id and installation id are
# identifiers and are kept here as configuration.
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: arc-github-app
  namespace: ${runners_namespace}
spec:
  refreshInterval: 1h0m0s
  secretStoreRef:
    kind: SecretStore
    name: azure-kv
  target:
    name: arc-github-app
    template:
      engine: v2
      data:
        # The chart looks these three keys up by name. The ids must be
        # strings -- unquoted they become numbers and the listener rejects them.
        github_app_id: "${github_app_id}"
        github_app_installation_id: "${github_app_installation_id}"
        github_app_private_key: "{{`{{ .privateKey }}`}}"
  data:
    - secretKey: privateKey
      remoteRef:
        key: ${key_vault_secret_name}
---
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: azure-kv
  namespace: ${runners_namespace}
spec:
  provider:
    azurekv:
      authType: WorkloadIdentity
      environmentType: PublicCloud
      serviceAccountRef:
        name: ${eso_service_account_name}
      tenantId: ${azure_tenant_id}
      useAzureSDK: false
      vaultUrl: https://${key_vault_name}.vault.azure.net
---
# Workload identity federation binds to system:serviceaccount:<ns>:<sa>; the
# matching federated credential lives in this module's workload-identity.tf.
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${eso_service_account_name}
  namespace: ${runners_namespace}
  annotations:
    azure.workload.identity/client-id: ${eso_client_id}
