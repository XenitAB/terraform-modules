apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: ${key_vault_name}
  namespace: argocd
spec:
  provider:
    azurekv:
      vaultUrl: "${vault_url}"
      authType: "WorkloadIdentity"
      serviceAccountRef:
        name: argocd-application-controller
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
  name: argocd-gateway
  namespace: argocd
spec:
  gatewayClassName: ${tenant_name}-${environment}
  listeners:
    - name: https
      hostname: ${global_domain}
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: argocd-tls
      allowedRoutes:
        namespaces:
          from: All
---
%{ for azure_tenant in azure_tenants ~}
%{ for cluster in azure_tenant.clusters ~}
%{ if cluster.api_server != "https://kubernetes.default.svc" }
apiVersion: v1
kind: Secret
metadata:
  name: cluster-${azure_tenant.tenant_name}-${cluster.environment}
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name:  cluster-${azure_tenant.tenant_name}-${cluster.environment}
  server: ${cluster.api_server}
  config: |
    {
      "execProviderConfig": {
        "command": "argocd-k8s-auth",
        "env": {
          "AAD_ENVIRONMENT_NAME": "AzurePublicCloud",
          "AZURE_CLIENT_ID": "${cluster.azure_client_id}",
          "AZURE_TENANT_ID": "${azure_tenant.tenant_id}",
          "AZURE_FEDERATED_TOKEN_FILE": "/var/run/secrets/tokens/${azure_tenant.tenant_name}-${cluster.environment}-federated-token-file",
          "AZURE_AUTHORITY_HOST": "https://login.microsoftonline.com/",
          "AAD_LOGIN_METHOD": "workloadidentity"
        },
        "args": ["azure"],
        "apiVersion": "client.authentication.k8s.io/v1beta1"
      },
      "tlsClientConfig": {
        "insecure": false,
        "caData": "${cluster.ca_data}
      }
    }
---
%{ endif }
%{ for tenant in cluster.tenants ~}
apiVersion: v1
kind: Namespace
metadata:
  name: ${tenant.namespace}-${cluster.environment}
  labels:
    xkf.xenit.io/kind: platform
spec:
  finalizers:
    - kubernetes
---
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: ${tenant.namespace}-${cluster.environment}-tenant
spec:
  # Allow Application resources to deploy only into these namespaces
  sourceNamespaces:
  - "argocd"
  - "${tenant.namespace}-${cluster.environment}"
  # Allow manifests to deploy from specific repository (url) only
  sourceRepos:
  - "*"
  # Only permit applications to deploy to these namespace in the given cluster
  destinations:
  - namespace: "argocd"
    server: "https://kubernetes.default.svc"
  - namespace: "${tenant.namespace}-${cluster.environment}"
    server: "https://kubernetes.default.svc"
  - namespace: "${tenant.namespace}"
    server: "${cluster.api_server}"
  clusterResourceWhitelist:
  - group: "*"
    kind: "*"
  roles:
  - name: ${tenant.namespace}-${cluster.environment}-role
    description: Default role that will be applied to this project.
    groups:
    - ${tenant.aad_group}
    policies:
    - p, proj:${tenant.namespace}-${cluster.environment}-tenant:${tenant.namespace}-${cluster.environment}-role, applications, *, *, allow
    - p, proj:${tenant.namespace}-${cluster.environment}-tenant:${tenant.namespace}-${cluster.environment}-role, applicationsets, *, *, allow
    - p, proj:${tenant.namespace}-${cluster.environment}-tenant:${tenant.namespace}-${cluster.environment}-role, repositories, *, *, allow
  syncWindows:
  %{ for sync_window in sync_windows ~}
  - kind: "${sync_window.kind}"
      schedule: "${sync_window.schedule}"
      timeZone: "Europe/Stockholm"
      duration: "${sync_window.duration}"
      manualSync: ${sync_window.manual_sync}
  %{ endfor }
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${tenant.namespace}-${cluster.environment}-tenant
  namespace: ${tenant.namespace}-${cluster.environment}
spec:
  destination:
    namespace: ${tenant.namespace}-${cluster.environment}
    server: https://kubernetes.default.svc
  project: ${tenant.namespace}-${cluster.environment}-tenant
  revisionHistoryLimit: 5
  source:
    path: ${tenant.repo_path}
    repoURL: ${tenant.repo_url}
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
    syncOptions:
      - RespectIgnoreDifferences=true
      - ApplyOutOfSyncOnly=true
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: repo-${tenant.name}-${cluster.environment}
  namespace: argocd
spec:
  refreshInterval: 10m
  secretStoreRef:
    kind: SecretStore
    name: ${key_vault_name}
  target:
    name: repo-${tenant.name}-${cluster.environment}
    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: repository
      data:
        name: ${tenant.name}-${cluster.environment}
        url: ${tenant.repo_url}
        githubAppID: ${tenant.github_app_id}
        githubAppInstallationID: ${tenant.github_installation_id}
      mergePolicy: Merge
  data:
  - secretKey: githubAppPrivateKey
    remoteRef:
      key: ${tenant.secret_name}
---
%{ endfor }
%{ endfor }
%{ endfor }