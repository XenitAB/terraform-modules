
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Provider
metadata:
  name: slack
  namespace: flux-system
spec:
  type: slack
  channel: xks-alerts
  address: "${slack_flux_alert_config.xenit_webhook}"
---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Provider
metadata:
  name: slack-customer
  namespace: flux-system
spec:
  type: slack
  channel: flux-tenant-alerts
  address: "${slack_flux_alert_config.tenant_webhook}"

---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: flux-reconciliation
  namespace: flux-system
spec:
  summary: "Customer: ${azure_devops_org} Env: ${cluster_id}. These are only Xenit related flux generated alerts"
  providerRef:
    name: slack
  eventSeverity: info
  eventSources:
    - kind: GitRepository
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: flux-system
    - kind: Kustomization
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: flux-system
    - kind: HelmRelease
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: flux-system

---
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Alert
metadata:
  name: flux-reconciliation
  namespace: flux-system
spec:
  summary: "Organization: ${azure_devops_org} Env: ${cluster_id}. These are ${azure_devops_org} flux generated alerts"
  providerRef:
    name: slack-customer
  eventSeverity: info
  eventSources:
    - kind: GitRepository
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: tenants
    - kind: Kustomization
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: tenants    
    - kind: HelmRelease
      name: '*'
      matchLabels:
        kustomize.toolkit.fluxcd.io/name: tenants